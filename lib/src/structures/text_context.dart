import 'package:nyxx/nyxx.dart';

/// Representation of useful context information regarding a text command trigger message.
class TextCommandContext {
  /// Author of the message that triggered the command.
  final IMessageAuthor author;

  /// Channel the message was sent in.
  final ITextChannel channel;

  /// Nyxx client, used for utilizing Nyxx client methods within the command or subcommand
  /// implementation message.
  final INyxxRest client;

  /// The part of the message that triggered the command, including the prefix.
  final String commandTrigger;

  /// Guild that the message was sent in, if any.
  final IGuild? guild;

  /// The message object of the triggering message.
  final IMessage message;

  /// Instantiate the context around a command triggering message.
  TextCommandContext(this.client, this.author, this.channel, this.commandTrigger, this.guild, this.message);
}
