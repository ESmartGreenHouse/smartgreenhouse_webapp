import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:greenhouse_repository/greenhouse_repository.dart';
import 'package:meta/meta.dart';
import 'package:smartgreenhouse_app/authentication/authentication.dart';
import 'package:smartgreenhouse_app/particles_dialog/particles_dialog.dart';

part 'particles_dialog_state.dart';

class ParticlesDialogCubit extends Cubit<ParticlesDialogState> {
  final GreenhouseRepository greenhouseRepository;
  final AuthenticationBloc authenticationBloc;

  ParticlesDialogCubit({
    @required this.greenhouseRepository,
    @required this.authenticationBloc,
  }) : assert(greenhouseRepository != null),
       assert(authenticationBloc != null),
       super(ParticlesDialogState());

  void nameChanged(String value) {
    final name = ParticleName.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([name, state.description, state.mac])
    ));
  }

  void descriptionChanged(String value) {
    final description = ParticleDescription.dirty(value);
    emit(state.copyWith(
      description: description,
      status: Formz.validate([state.name, description, state.mac])
    ));
  }

  void macChanged(String value) {
    final mac = ParticleMac.dirty(value);
    emit(state.copyWith(
      mac: mac,
      status: Formz.validate([state.name, state.description, mac])
    ));
  }

  Future<void> submit() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final result = await greenhouseRepository.addParticle(Particle(
      id: state.mac.value,
      name: state.name.value,
      description: state.description.value,
      ownerUid: authenticationBloc.state.user.id,
      sensors: [],
    ));

    if (result) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}