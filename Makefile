client-build:
	rm -f -r  ./mailserver-configurator-client/dist/
	cd ./mailserver-configurator-client; npm install
	cd ./mailserver-configurator-client; npm run build

interface-copy-client:
	rm -r ./mailserver-configurator-interface/public/*
	cp -r ./mailserver-configurator-client/dist/* ./mailserver-configurator-interface/public/

interface-install-deps:
	go get github.com/go-sql-driver/mysql
	go get github.com/go-chi/cors
	go get gopkg.in/unrolled/render.v1
	go get github.com/go-chi/chi
	go get github.com/rakyll/statik
	go get github.com/99designs/basicauth-go

interface-build:
	cd ./mailserver-configurator-interface; ~/go/bin/statik -f -src=./public
	cd ./mailserver-configurator-interface; go build -o ../go-mail-admin-with-gui ./

interface-compile:
	echo "Compiling for every OS and Platform"
	rm -f ./bin/*
	cd ./mailserver-configurator-interface; GOOS=linux GOARCH=386 go build -o ../bin/go-mail-admin-with-gui-linux-386 ./
	cd ./mailserver-configurator-interface; GOOS=linux GOARCH=arm go build -o ../bin/go-mail-admin-with-gui-linux-arm ./
	cd ./mailserver-configurator-interface; GOOS=linux GOARCH=arm64 go build -o ../bin/go-mail-admin-with-gui-linux-arm64 ./
	cd ./mailserver-configurator-interface; GOOS=linux GOARCH=amd64 go build -o ../bin/go-mail-admin-with-gui-linux-amd64 ./

deb-i386:
	cp ./bin/go-mail-admin-with-gui-linux-386 ./resources/debpkg-i386/opt/go-mail-admin/go-mail-admin-with-gui-linux-386
	cd ./resources/; dpkg-deb --build ./debpkg-i386
	mv ./resources/debpkg-i386.deb ./bin/go-mail-admin-i386.deb

deb-amd64:
	cp ./bin/go-mail-admin-with-gui-linux-amd64 ./resources/debpkg-amd64/opt/go-mail-admin/go-mail-admin-with-gui-linux-amd64
	cd ./resources/; dpkg-deb --build ./debpkg-amd64
	mv ./resources/debpkg-amd64.deb ./bin/go-mail-admin-amd64.deb

deb-arm:
	cp ./bin/go-mail-admin-with-gui-linux-arm ./resources/debpkg-amd64/opt/go-mail-admin/go-mail-admin-with-gui-linux-arm
	cd ./resources/; dpkg-deb --build ./debpkg-arm
	mv ./resources/debpkg-arm.deb ./bin/go-mail-admin-arm.deb


build: client-build interface-copy-client interface-install-deps interface-build
compile: client-build interface-copy-client interface-install-deps interface-compile
all: compile deb-i386 deb-amd64 deb-arm