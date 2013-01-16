pomelo-flashchat
==================

* This is a chat application using flash client for pomelo, the server side is chatofpomelo(https://github.com/NetEase/chatofpomelo).

## Demo

We're working on the demo, but currently facing some Flash-in-browser security issues.

![Flash Chat](https://dl.dropbox.com/u/58484258/pomelo-flashchat.jpg)

## Dependency

Support dependencies for `pomelo-flashchat` are already included. There is a dependency of these open-source projects:

* [pomelo-flashclient](https://github.com/stokegames/pomelo-flashclient)

## Flash socket policy file

This implementation uses Flash sockets, which means that your server must provide Flash socket policy file to declare the server accepts connections from Flash.

Pomelo uses Socket.io, which should provide the policy file on port 10843, but there's difficulty getting it working at the moment, and it's better to provide the socket policy file at port 843. Flash always tries to connect the port 843, so providing the file at port 843 which makes the startup faster. You can use a Node.js server for that here: [pomelo-flashpolicyserver](https://github.com/stokegames/pomelo-flashpolicyserver)

## Contributors
* NetEase, Inc.
* Eric Muyser

## License

(The MIT License)

Copyright (c) 2013 Netease, Inc. and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.