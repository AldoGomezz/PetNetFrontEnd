import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/presentation/presentation.dart';

class ProfileInfoForm extends ConsumerWidget {
  const ProfileInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    _listenToUpdateError(context, ref);
    _listenToUpdateResponse(context, ref);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              //Background
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: BackgroundWidget(),
              ),
              //Boton de regreso
              Positioned(
                top: size.height * 0.05,
                left: size.width * 0.02,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              //Content
              Positioned(
                top: size.height * 0.05,
                child: const ProfileFormWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listenToUpdateError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      profileUpdateProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(profileUpdateProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(profileUpdateProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      profileUpdateProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(profileUpdateProvider.notifier).resetResponse();
        }
      },
    );
  }
}
