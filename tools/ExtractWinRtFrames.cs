using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Windows.Graphics.Imaging;
using Windows.Media.Editing;
using Windows.Storage;

internal static class ExtractWinRtFrames
{
    private static int Main(string[] args)
    {
        try
        {
            Run(args).GetAwaiter().GetResult();
            return 0;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine(ex);
            return 1;
        }
    }

    private static async Task Run(string[] args)
    {
        if (args.Length < 2)
        {
            throw new ArgumentException("Usage: ExtractWinRtFrames <videoPath> <outDir> [count]");
        }

        string videoPath = Path.GetFullPath(args[0]);
        string outDir = Path.GetFullPath(args[1]);
        int count = args.Length >= 3 ? int.Parse(args[2]) : 12;
        Directory.CreateDirectory(outDir);

        StorageFile file = await StorageFile.GetFileFromPathAsync(videoPath).AsTask();
        MediaClip clip = await MediaClip.CreateFromFileAsync(file).AsTask();
        var composition = new MediaComposition();
        composition.Clips.Add(clip);

        TimeSpan duration = clip.OriginalDuration;
        var jsonLines = new List<string>();
        jsonLines.Add("{");
        jsonLines.Add("  \"durationSeconds\": " + duration.TotalSeconds.ToString(System.Globalization.CultureInfo.InvariantCulture) + ",");
        jsonLines.Add("  \"frames\": [");

        for (int i = 0; i < count; i++)
        {
            double pct = (i + 1.0) / (count + 1.0);
            double seconds = Math.Max(0.25, Math.Min(duration.TotalSeconds - 0.25, duration.TotalSeconds * pct));
            ImageStream image = await composition.GetThumbnailAsync(
                TimeSpan.FromSeconds(seconds),
                1280,
                720,
                VideoFramePrecision.NearestFrame).AsTask();

            string filename = "frame_" + (i + 1).ToString("D2") + "_" + Math.Round(seconds).ToString("0") + "s.jpg";
            string outPath = Path.Combine(outDir, filename);
            using (Stream input = image.AsStreamForRead())
            using (FileStream output = File.Create(outPath))
            {
                input.CopyTo(output);
            }

            jsonLines.Add("    { \"index\": " + (i + 1) + ", \"time\": " + seconds.ToString(System.Globalization.CultureInfo.InvariantCulture) + ", \"file\": \"" + filename.Replace("\\", "\\\\") + "\" }" + (i == count - 1 ? "" : ","));
            Console.WriteLine(filename);
        }

        jsonLines.Add("  ]");
        jsonLines.Add("}");
        File.WriteAllLines(Path.Combine(outDir, "frames.json"), jsonLines);
    }
}
