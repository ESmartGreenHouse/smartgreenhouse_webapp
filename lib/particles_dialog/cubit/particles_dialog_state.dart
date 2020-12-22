part of 'particles_dialog_cubit.dart';

class ParticlesDialogState extends Equatable {
  final ParticleName name;
  final ParticleDescription description;
  final ParticleMac mac;
  final FormzStatus status;

  const ParticlesDialogState({
    this.name = const ParticleName.pure(),
    this.description = const ParticleDescription.pure(),
    this.mac = const ParticleMac.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [name, description, mac, status];

  ParticlesDialogState copyWith({
    ParticleName name,
    ParticleDescription description,
    ParticleMac mac,
    FormzStatus status,
  }) => ParticlesDialogState(
    name: name ?? this.name,
    description: description ?? this.description,
    mac: mac ?? this.mac,
    status: status ?? this.status,
  );

   @override
   String toString() => 'ParticlesDialogState { name: $name }';
}