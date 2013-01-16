package {
  public class Chat 
  {
    import com.netease.pomelo.Client;
    import com.netease.pomelo.events.ClientEvent;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.SimpleButton;
    import flash.text.Font;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.globalization.DateTimeFormatter;

    protected var client:Client;
    protected var root:MovieClip;
    protected var chatHistory:TextField;
    protected var chatInput:TextField;
    protected var chatInputSubmit:SimpleButton;

    public function Chat(root):void {
      this.root = MovieClip(root);

      this.createChatHistory();
      this.createChatInput();
      this.connectToServer();
    }

    public function connectToServer():void {
      var self:Chat = this;
      var host:String = "127.0.0.1";
      var port:int = 3014;

      this.client = new Client();

      //wait message from the server
      this.client.on('onChat', function(data):void {
        self.addMessage(data.from, data.target, data.msg, (new Date()).getTime());
        //$("#chatHistory").show();
        //if(data.from !== username)
        //  tip('message', data.from);
      });

      // update user list
      this.client.on('onAdd', function(data) {
        var user:String = data.user;
        //tip('online', user);
        //addUser(user);
      });

      // update user list
      this.client.on('onLeave', function(data) {
        var user:String = data.user;
        //tip('offline', user);
        //removeUser(user);
      });

      // handle disconect message, occours when the client is disconnect with servers
      this.client.on('disconnect', function(reason) {
        //showLogin();
      });

      this.client.init(host, port, null, function():void {
        //handle data here
        self.client.request("gate.gateHandler.queryEntry", {
          uid: "DemoUser"
        }, function(data:Object) {
          //handle data here
          self.client.init(data.host, data.port, null, function():void {
            self.client.request("connector.entryHandler.enter", {
              username: "DemoUser",
              rid: "Pomelo" // room ID
            }, function(data:Object) {
              //handle data here
              if(data.error) {
                trace('Duplicate username')
              }
            });
          });
        });
      });
    }

    public function createChatHistory():void {
      this.chatHistory = new TextField();

      var f1:TextFormat = new TextFormat();

      f1.color = 0x000000; 
      f1.size = 14;
      f1.italic = false;
      f1.font = "Arial";

      this.chatHistory.setTextFormat(f1);

      this.chatHistory.htmlText = '';
      this.chatHistory.width = 650;
      this.chatHistory.height = 300;
      this.chatHistory.x = 25;
      this.chatHistory.y = 25;
      this.chatHistory.selectable = true;
      this.chatHistory.border = false;
      this.chatHistory.wordWrap = true;
      this.chatHistory.multiline = true;
      this.chatHistory.opaqueBackground = 0xCCCCCC;

      this.root.addChild(this.chatHistory);
    }

    public function createChatInput():void {
      var self:Chat = this;

      this.chatInput = new TextField();

      var f1:TextFormat = new TextFormat();

      f1.color = 0x222222; 
      f1.size = 16;
      f1.italic = false;
      f1.font = "Arial";

      this.chatInput.setTextFormat(f1);

      this.chatInput.htmlText = 'Type here...';
      this.chatInput.width = 650;
      this.chatInput.height = 30;
      this.chatInput.x = 25;
      this.chatInput.y = 335;
      this.chatInput.selectable = true;
      this.chatInput.border = true;
      this.chatInput.borderColor = 0x999999;
      this.chatInput.opaqueBackground = 0xCCCCCC;
      this.chatInput.type = TextFieldType.INPUT;

      this.root.addChild(this.chatInput);

      this.chatInput.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
         if(e.charCode == 13) { // enter key
            self.client.request("chat.chatHandler.send", {
              rid: "Pomelo",
              content: self.chatInput.text,
              from: "DemoUser",
              target: '*'
            }, function(data:Object):void {
              //handle data here
            });

            self.chatInput.htmlText = '';
         }
      });

      var text1:TextField = new TextField();
      text1.name = "text1";
      text1.mouseEnabled = false;
      text1.x = 2;
      text1.y = 2;

      f1.color = 0xFFFFFF; 
      f1.size = 16;
      f1.italic = false;
      f1.font = "Arial";

      text1.setTextFormat(f1);

      var shape1:Shape = new Shape();
      shape1.graphics.beginFill(0x5fbf5f);
      shape1.graphics.drawRect(0, 0, 75, 22);
      shape1.graphics.endFill();

      var sprite1:Sprite = new Sprite();
      sprite1.name = "shape1";
      sprite1.x = 595;
      sprite1.y = 340;
      sprite1.addChild(shape1);
      sprite1.addChild(text1);
      sprite1.useHandCursor = true;
      sprite1.buttonMode = true;
      sprite1.mouseChildren = false;

      this.chatInputSubmit = new SimpleButton();
      this.chatInputSubmit.upState = sprite1;
      this.chatInputSubmit.overState = sprite1;
      this.chatInputSubmit.downState = sprite1;
      this.chatInputSubmit.hitTestState = sprite1;

      var container1:DisplayObjectContainer = DisplayObjectContainer(this.chatInputSubmit.upState);

      var tf:TextField = TextField(container1.getChildByName("text1"));  
      tf.text = "Submit";

      this.root.addChild(this.chatInputSubmit);

      this.chatInputSubmit.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
        if(!self.chatInput.text)
          return; // no input

        self.client.request("chat.chatHandler.send", {
          rid: "Pomelo",
          content: self.chatInput.text,
          from: "DemoUser",
          target: '*'
        }, function(data:Object):void {
          //handle data here
        });

        self.chatInput.htmlText = '';
      });
    }

    public function addMessage(from:String, target:String, msg:String, timestamp:Number):void {
      var name:String = (target == '*' ? 'all' : target);
      var d1 = new Date();
      d1.setTime(timestamp);

      var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
      dtf.setDateTimePattern("hh:mma");

      this.chatHistory.htmlText += '<b><font color="#006699">' + from + '</font> says to ' + name + ' (</b><font color="#999999" size="-2">' + dtf.format(d1) + '</font>): <font color="#000000">' + msg + '</font><br>';
    }
  }
}