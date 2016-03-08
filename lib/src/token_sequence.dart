library markov.token_sequence;

import 'dart:collection';

import 'package:markov/src/token.dart';
import 'package:quiver/core.dart';

class TokenSequence {
  final Queue<Token> _tokens;

  TokenSequence(Iterable<Token> tokens) : _tokens = new Queue.from(tokens);
  TokenSequence.fromString(String str)
      : this(str.split(" ").map((string) => new Token(string)));

  @override
  int get hashCode => hashObjects(_tokens.map((token) => token.string));

  @override
  operator ==(TokenSequence other) => hashCode == other.hashCode;

  TokenSequence createNext(Token nextToken) {
    var nextTokens = new Queue.from(_tokens);
    nextTokens.removeFirst();
    nextTokens.addLast(nextToken);
    return new TokenSequence(nextTokens);
  }

  String toString() => _tokens.map((t) => t.string).join(" "); // TODO
}
