
docker build -t vscode-server .

docker run -d -p 8080:8080 -e PASSWORD=your_password vscode-server


----


docker build -t devenv .

docker run -d -p 80:80 devenv

