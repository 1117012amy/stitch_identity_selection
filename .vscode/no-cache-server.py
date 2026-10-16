from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import argparse
import os


class NoCacheRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bind", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8082)
    parser.add_argument("--directory", required=True)
    args = parser.parse_args()

    os.chdir(args.directory)
    server = ThreadingHTTPServer((args.bind, args.port), NoCacheRequestHandler)
    print(f"Serving no-cache preview at http://{args.bind}:{args.port}/")
    server.serve_forever()


if __name__ == "__main__":
    main()
