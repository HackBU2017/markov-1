library markov.chain;

import 'dart:math';

import 'package:markov/src/probability_distribution.dart';
import 'package:markov/src/token.dart';
import 'package:markov/src/token_sequence.dart';

class MarkovChain {
  static const totalCountKey = " "; // Space is an invalid token.
  final Map<TokenSequence, ProbabilityDistribution<String>> _edges = new Map();

  final int order;

  final Random _random;

  MarkovChain(this.order, {int randomSeed}) : _random = new Random(randomSeed);

  Map get asMap => _edges;

  Iterable<Token> generate({TokenSequence state: null}) sync* {
    if (state == null) {
      state = new TokenSequence(
          new List.filled(order, "\n").map((string) => new Token(string)));
    }

    while (true) {
      ProbabilityDistribution<String> distribution = _edges[state];
      String nextWord = distribution.pick(_random);
      var nextToken = new Token(nextWord);
      yield nextToken;
      state = new TokenSequence.fromPrevious(state, nextToken);
    }
  }

  void record(TokenSequence precedent, String word) {
    ProbabilityDistribution<String> distribution =
        _edges.putIfAbsent(precedent, () => new ProbabilityDistribution());
    distribution.record(word);
  }

  toJson() => {"edges": _edges, "order": order};
}
