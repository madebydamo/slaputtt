import 'dart:math';

import 'package:uttt_package/src/model/Evolution.dart';

class ParticleBase {
  Random random = Random();

  ParticleEra initialiseEra(
      int size, int depth, double w, double c1, double c2) {
    Random r = Random();
    List<ParticleRating> particles = List.generate(
        size,
        (i) => ParticleRating(Particle(r.nextDouble(), r.nextDouble(),
            r.nextDouble(), r.nextDouble(), r.nextDouble(), r.nextDouble())));
    ParticleEra era = ParticleEra(depth, w, c1, c2);
    era.generations.add(ParticleGeneration(particles));
    return era;
  }

  double evaluate(Particle particle) {
    // Define your objective function here based on Particle's properties
    return 0.0;
  }

  ParticleGeneration _mutateGeneration(ParticleGeneration generation) {
    List<ParticleRating> updatedParticles = [];

    Particle globalBest = generation.best;

    for (int i = 0; i < generation.ratings.length; i++) {
      // Update the velocity and position of each particle
      Particle updatedParticle =
          _updateParticle(generation.ratings[i], globalBest);

      // Add the updated particle with its new rating to the list
      updatedParticles.add(ParticleRating(updatedParticle));
    }

    // Return the new generation of particles
    return ParticleGeneration(updatedParticles);
  }

  Particle _updateParticle(ParticleRating rating, Particle globalBest) {
    double w = 0.5; // Inertia weight
    double c1 = 1; // Personal learning coefficient
    double c2 = 2; // Global learning coefficient

    Particle particle = rating.particle;
    // Update the particle's velocity and position
    DNA newVelocity = DNA(
        w * particle.velocity.smallOne +
            c1 *
                Random().nextDouble() *
                (particle.bestKnownPosition.smallOne - particle.smallOne) +
            c2 *
                Random().nextDouble() *
                (globalBest.smallOne - particle.smallOne),
        w * particle.velocity.smallTwo +
            c1 *
                Random().nextDouble() *
                (particle.bestKnownPosition.smallTwo - particle.smallTwo) +
            c2 *
                Random().nextDouble() *
                (globalBest.smallTwo - particle.smallTwo),
        w * particle.velocity.bigOne +
            c1 *
                Random().nextDouble() *
                (particle.bestKnownPosition.bigOne - particle.bigOne) +
            c2 * Random().nextDouble() * (globalBest.bigOne - particle.bigOne),
        w * particle.velocity.bigTwo +
            c1 *
                Random().nextDouble() *
                (particle.bestKnownPosition.bigTwo - particle.bigTwo) +
            c2 * Random().nextDouble() * (globalBest.bigTwo - particle.bigTwo),
        w * particle.velocity.bigThree +
            c1 *
                Random().nextDouble() *
                (particle.bestKnownPosition.bigThree - particle.bigThree) +
            c2 *
                Random().nextDouble() *
                (globalBest.bigThree - particle.bigThree),
        0.2);

    Particle newParticle = Particle(
        particle.smallOne + newVelocity.smallOne,
        particle.smallTwo + newVelocity.smallTwo,
        particle.bigOne + newVelocity.bigOne,
        particle.bigTwo + newVelocity.bigTwo,
        particle.bigThree + newVelocity.bigThree,
        particle.mutation);
    newParticle.velocity = newVelocity;

    // If the updated particle's position is better than its best known position, update the best known position
    if (rating.stats.value > particle.bestStats.value) {
      newParticle.bestKnownPosition = DNA(
          particle.smallOne,
          particle.smallTwo,
          particle.bigOne,
          particle.bigTwo,
          particle.bigThree,
          particle.mutation);
      newParticle.bestStats = Stats.fromJson(rating.stats.toJson());
    }

    return newParticle;
  }

  void mutate(ParticleEra era) {
    assert(era.currentState == trained,
        "You have to train your generation first!");
    ParticleGeneration generation = era.lastTrainedGen;
    era.generations.add(_mutateGeneration(generation));
    era.currentState = mutated;
  }
}
