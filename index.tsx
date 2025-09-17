import { serve } from "bun";
import { renderToReadableStream } from "react-dom/server";
import { join } from "path";
import fs from "fs";

const Skeleton: React.FC<React.PropsWithChildren<{}>> = ({ children }) => (
    <html>
        <head>
            <title>Taya Crystals</title>
            <meta charSet="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="stylesheet" href="/.assets/styles.css" />
        </head>
        <body>
            {children}
        </body>
        <footer>
            <p>Made by Taya<br/>Feel free to copy</p>
        </footer>
    </html>
)

const Error404 = () => (
    <Skeleton>
        <h1>404 - Not Found</h1>
    </Skeleton>
)


interface WindowSectionProps {
    path: string;
    children: React.ReactNode;
}
const WindowSection: React.FC<WindowSectionProps> = ({ path, children }) => (
    <section className="window">
        <h2>
            <a href="/">/home</a>
            <span>{path}</span>
        </h2>
        {children}
    </section>
);

const DirectoryListing: React.FC<{ path: string; items: { name: string, href: string, icon: string }[] }> = ({ path, items }) => (
    <Skeleton>
        <h1>Taya Crystals</h1>
        <WindowSection path={path}>
            <div className="icon-grid">
                {items.map(item => (
                    <a key={item.name} href={`${item.href}`}>
                        <img src={item.icon} alt={item.name} />
                        <span>{item.name}</span>
                    </a>
                ))}
            </div>
        </WindowSection>
    </Skeleton>
);

const HtmlViewer: React.FC<{ path: string; content: string }> = ({ path, content }) => (
    <Skeleton>
        <h1>Taya Crystals</h1>
        <WindowSection path={path}>
            <div className="file-viewer">
                <div dangerouslySetInnerHTML={{ __html: content }} />
            </div>
        </WindowSection>
    </Skeleton>
);

const ROOT = "./home"

serve({
    async fetch(request) {
        const url = new URL(request.url);

        // all paths should be relative to ROOT
        // if the path is a directory, serve DirectoryListing
        // if the path is a file, serve the file
        // if the path does not exist, serve Error404
        let path = decodeURIComponent(url.pathname);
        if (path.endsWith("/")) {
            path = path.slice(0, -1);
        }
        const fullPath = join(ROOT, path);

        if (fs.existsSync(fullPath) && fs.statSync(fullPath).isDirectory()) {
            // [{name: string, href: string, icon: string}]
            const items = []

            const entries = fs.readdirSync(fullPath);

            entries.sort((a, b) => {
                const aIsDir = fs.statSync(join(fullPath, a)).isDirectory();
                const bIsDir = fs.statSync(join(fullPath, b)).isDirectory();
                if (aIsDir && !bIsDir) return 1;
                if (!aIsDir && bIsDir) return -1;
                const aExt = a.split('.').pop();
                const bExt = b.split('.').pop();
                if (aExt === bExt) return 0;
                return aExt < bExt ? -1 : 1;
            });

            for (const path of entries) {
                if (path.startsWith('.')) continue;

                const item = { name: path, href: '', icon: "/.assets/icons/unknown.png" };

                if (path.endsWith('.lnk')) {
                    item.href = await Bun.file(join(fullPath, path)).text();
                } else {
                    item.href = join(url.pathname, path);
                }

                if (fs.statSync(join(fullPath, path)).isDirectory()) {
                    item.icon = "/.assets/icons/folder.png";
                } else if (path.endsWith('email.lnk')) {
                    item.icon = "/.assets/icons/mail.png";
                } else if (path.endsWith('.lnk')) {
                    item.icon = "/.assets/icons/link.png";
                } else if (path.endsWith('.jpg') || path.endsWith('.png')) {
                    item.icon = "/.assets/icons/image.png";
                } else if (path.endsWith('.html') || path.endsWith('.txt') || path.endsWith('.pdf')) {
                    item.icon = "/.assets/icons/file.png";
                }

                items.push(item);
            }

            const stream = await renderToReadableStream(<DirectoryListing path={path} items={items} />);
            return new Response(stream, { headers: { "Content-Type": "text/html" }});
        }

        // if file
        if (fs.existsSync(fullPath) && fs.statSync(fullPath).isFile()) {

            // special cases
            if (path.endsWith('.html')) {
                // render into HtmlViewer
                const content = await Bun.file(fullPath).text();
                const stream = await renderToReadableStream(<HtmlViewer path={path} content={content} />);

                return new Response(stream, { headers: { "Content-Type": "text/html" }});
            }

            return new Response(fs.createReadStream(fullPath));
        }

        // if neither, 404
        const stream = await renderToReadableStream(<Error404 />);
        return new Response(stream, { status: 404, headers: { "Content-Type": "text/html" }});

    },
    websocket: undefined,
    development: true,
});