const fs = require('fs');
const path = require('path');
const { pathToFileURL } = require('url');
const { chromium } = require('playwright');

async function launchBrowser() {
  try {
    return await chromium.launch({ channel: 'msedge', headless: true });
  } catch {
    return chromium.launch({ headless: true });
  }
}

async function main() {
  const videoPath = process.argv[2];
  const outDir = process.argv[3] || path.resolve('vlog_cover_work');
  const count = Number(process.argv[4] || 12);

  if (!videoPath || !fs.existsSync(videoPath)) {
    throw new Error(`Video not found: ${videoPath}`);
  }

  fs.mkdirSync(outDir, { recursive: true });
  const browser = await launchBrowser();
  const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });
  const videoUrl = pathToFileURL(path.resolve(videoPath)).href;

  const result = await page.evaluate(
    async ({ videoUrl, outCount }) => {
      const video = document.createElement('video');
      video.src = videoUrl;
      video.muted = true;
      video.preload = 'auto';
      video.playsInline = true;
      document.body.appendChild(video);

      await new Promise((resolve, reject) => {
        video.onloadedmetadata = resolve;
        video.onerror = () => reject(new Error('Video metadata failed to load'));
      });

      const duration = video.duration;
      const width = video.videoWidth;
      const height = video.videoHeight;
      const canvas = document.createElement('canvas');
      const targetWidth = 1280;
      const targetHeight = Math.round((height / width) * targetWidth);
      canvas.width = targetWidth;
      canvas.height = targetHeight;
      const ctx = canvas.getContext('2d');

      const times = Array.from({ length: outCount }, (_, i) => {
        const pct = (i + 1) / (outCount + 1);
        return Math.max(0.25, Math.min(duration - 0.25, duration * pct));
      });

      const frames = [];
      for (const time of times) {
        video.currentTime = time;
        await new Promise((resolve, reject) => {
          const timer = setTimeout(() => reject(new Error(`Seek timed out at ${time}`)), 20000);
          video.onseeked = () => {
            clearTimeout(timer);
            resolve();
          };
        });
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        const dataUrl = canvas.toDataURL('image/png');
        frames.push({ time, dataUrl });
      }

      return { duration, width, height, frames };
    },
    { videoUrl, outCount: count }
  );

  result.frames.forEach((frame, index) => {
    const base64 = frame.dataUrl.replace(/^data:image\/png;base64,/, '');
    const filename = `frame_${String(index + 1).padStart(2, '0')}_${Math.round(frame.time)}s.png`;
    fs.writeFileSync(path.join(outDir, filename), Buffer.from(base64, 'base64'));
  });

  fs.writeFileSync(
    path.join(outDir, 'frames.json'),
    JSON.stringify(
      {
        video: videoPath,
        duration: result.duration,
        width: result.width,
        height: result.height,
        frames: result.frames.map((frame, index) => ({
          index: index + 1,
          time: frame.time,
          file: `frame_${String(index + 1).padStart(2, '0')}_${Math.round(frame.time)}s.png`,
        })),
      },
      null,
      2
    )
  );

  await browser.close();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
