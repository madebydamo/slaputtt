import 'package:uttt_package/src/model/Algorithm.dart';
import 'package:uttt_package/src/model/Evolution.dart';
import 'package:uttt_package/src/model/GameState.dart';
import 'package:uttt_package/src/controller/heuristic/HeuristicCache.dart';

class HeuristicAlphaBeta implements Heuristic {
  DNA dna;

  HeuristicAlphaBeta(this.dna);

  void initCache() {
    cache;
  }

  @override
  double evaluateState(GameState state, State primaryState) {
    return evaluateForState(state, primaryState) - evaluateForState(state, State.flip(primaryState));
  }

  double evaluateForState(GameState state, State primaryState) {
    double value = 0.0;
    if(cache[state.value][primaryState].three > 0) {
      value += cache[state.value][primaryState].three * dna.bigThree;
    } else {
      state.tiles.map((b) => cache[b.value][primaryState]).forEach((info) {
        if(info.three == 0) {
          value += info.one * dna.smallOne;
          value += info.two * dna.smallTwo;
        }
      });
      value += cache[state.value][primaryState].one * dna.bigOne;
      value += cache[state.value][primaryState].two * dna.bigTwo;
    }
    return value;
  }

  factory HeuristicAlphaBeta.fromJson(Map<String, dynamic> json) {
    HeuristicAlphaBeta heuristic = HeuristicAlphaBeta(DNA.fromJson(json["dna"]));
    heuristic.initCache();
    return heuristic;
  }

  Map<String, dynamic> toJson() {
    return {"dna": dna.toJson(),};
  }
}


