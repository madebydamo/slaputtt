import 'package:uttt_package/src/model/Evolution.dart';

abstract class Wrapper {
  int length();
  DNA getBest(int index);
}

class EvolutionWrapper extends Wrapper {
  Era era;

  EvolutionWrapper(this.era);

  int length() => era.generations.length;

  DNA getBest(int index) => era.generations[index].best;
}

class ParticleWrapper extends Wrapper {
  ParticleEra era;

  ParticleWrapper(this.era);

  int length() => era.generations.length;

  DNA getBest(int index) => era.generations[index].best;
}
