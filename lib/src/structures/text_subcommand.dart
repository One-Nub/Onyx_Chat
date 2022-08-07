import 'text_command.dart';
import 'text_context.dart';

/// Base Subcommand representation
/// 
/// Extend this to create a Subcommand.
abstract class TextSubcommand {
  /// Parent command of the subcommand.
  late TextCommand parentCommand;

  /// Name of the subcommand, this will be used to trigger the subcommand.
  late String name;

  /// Optional description for the subcommand, useful for help commands.
  late String? description;

  /// Entry point of the subcommand, this method will run on command trigger.
  Future<void> commandEntry(TextCommandContext ctx, String messageContent,
    List<String> args);

  @override
  bool operator ==(Object other) {
    return other is TextSubcommand &&
      other.name == name &&
      other.parentCommand == parentCommand;
  }
}