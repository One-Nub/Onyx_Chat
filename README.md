# Onyx_Chat
The chat-based counterpart for my little ecosystem of Discord bot command frameworks for Dart. 

Onyx Chat is for legacy chat-based command handling, and as such is only best reserved for smaller, or private, chatbots.

Updates will be rather minimal + rare since I only have one bot that utilizes this library at this point, and I still
feel like there are better ways to handle chat commands than how I have done it here. But with chat commands being
pushed out, I would suggest using one of my other libraries listed below, or even the ones provided by those maintaining Nyxx.

---

## Some important information!
Chat commands are not the preferred way of handling commands for Discord anymore. What this means is that for growth and reachability, 
it is expected that [application commands](https://discord.com/developers/docs/interactions/application-commands) are used instead. 
I'd personally suggest using [Lirx](https://github.com/One-Nub/lirx) and the [Onyx](https://github.com/One-Nub/Onyx) packages 
for creating and integrating application commands, but I may be a little biased as the developer for each. 

If you're just getting started with creating application commands for the first time, I would instead suggest using Nyxx's dedicated 
[interaction](https://github.com/nyxx-discord/nyxx_interactions) and [command](https://github.com/nyxx-discord/nyxx_commands) 
frameworks due to the reduced barrier to entry. 

Since this is chat based, Onyx Chat is tied
closely to the gateway connection provided by [Nyxx](https://github.com/nyxx-discord/nyxx), and requires the message content intent.

---

## Features

- **Nyxx compatability** <br>
    No need to reinvent the entire wheel for connecting to and sending requests to Discord! NyxxWebsocket & NyxxRest support included.
- **Customizable command structure** <br>
    With just a few elements required for a command, it is simple to extend the Command class and add as much as you want.
- **Common Text Converters** <br>
    Handle all those long ID and String conversions without all the code.
- **Enhanced argument parsing** <br>
    Arguments are split based upon single and double quote matches, as well as by spaces.
---

## Getting started

> Since Onyx Chat is based upon a prior standard that is not focused on for large bot growth anymore, I have decided to not publish it to the [Dart package repository](pub.dev). Thus, to utilize Onyx Chat in your code, you must get it from the github repository.

### Add Onyx_Chat to your pubspec:
```yaml
#...
dependencies:
    onyx_chat:
        git: https://github.com/One-Nub/Onyx_Chat
#...
```

### Use Onyx_Chat in your code:
```dart
import package:onyx_chat/onyx_chat.dart
```

---

## Usage



### Initialization
```dart
import 'dart:collection';

import 'package:nyxx/nyxx.dart';
import 'package:onyx_chat/onyx_chat.dart';

void main() async {
  int intents = GatewayIntents.allUnprivileged | GatewayIntents.messageContent;
  INyxxWebsocket nyxxGateway = NyxxFactory.createNyxxWebsocket('TOKEN', intents)
    ..registerPlugin(CliIntegration())
    ..registerPlugin(Logging())
    ..registerPlugin(IgnoreExceptions())
    ..connect();

  OnyxChat onyx = OnyxChat(nyxxGateway, prefix: ".");
  onyx.addCommand(ExampleCommand());

  nyxxGateway.eventsWs.onMessageReceived.listen((event) {
    if(event.message.author.bot) return;
    
    onyx.dispatchIMessage(event.message);
  });
}
```

### Sample Command w/ Subcommand
```dart
class ExampleCommand extends TextCommand {
  @override
  String get name => "example";

  @override
  get aliases => HashSet.from({"test", "prototype"});

  @override
  get subcommands => HashSet.from({ExampleSubcommand()});

  @override
  Future<void> commandEntry(TextCommandContext ctx, String message, List<String> args) async {
    print("Args: $args");
    if(ctx.guild == null) {
      ctx.channel.sendMessage(MessageBuilder()..content = "This command can only be run in a guild!");
      return;
    }
    ctx.channel.sendMessage(MessageBuilder()..content = "Sample command was triggered!"
      ..replyBuilder = ReplyBuilder(ctx.message.id));
  }
}
```

### Sample Subcommand (utilized above)
```dart
class ExampleSubcommand extends TextSubcommand {
  @override
  get name => "sub";

  @override 
  get parentCommand => ExampleCommand();

  @override
  Future<void> commandEntry(TextCommandContext ctx, String messageContent, List<String> args) async {
        print("Args: $args");
        ctx.channel.sendMessage(MessageBuilder()
            ..content = "Hello from subcommand $name!"
            ..replyBuilder = ReplyBuilder(ctx.message.id)
        );
    }
}
```
