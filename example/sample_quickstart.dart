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