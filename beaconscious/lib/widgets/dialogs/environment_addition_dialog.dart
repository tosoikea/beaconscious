import 'package:beaconscious/blocs/environments/environments.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog.dart';
import 'package:beaconscious/widgets/dialogs/custom_dialog_column.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EnvironmentAdditionDialog extends StatefulWidget {
  const EnvironmentAdditionDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnvironmentAdditionDialogState();
}

class _EnvironmentAdditionDialogState extends State<EnvironmentAdditionDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = true;
  bool _iconHasError = true;

  List<IconData> _getIcons() => [
        Icons.search,
        Icons.home,
        Icons.settings,
        Icons.check_circle,
        Icons.favorite,
        Icons.star,
        Icons.bolt,
        Icons.key,
        Icons.person,
        Icons.group,
        Icons.public,
        Icons.support_agent,
        Icons.rocket_launch,
        Icons.psychology,
        Icons.pets,
        Icons.eco,
        Icons.forest,
        Icons.bedtime,
        Icons.elderly,
        Icons.egg,
        Icons.outdoor_grill,
        Icons.build,
        Icons.flutter_dash,
        Icons.school,
        Icons.sports_soccer,
        Icons.sports_esports,
        Icons.print,
        Icons.self_improvement,
        Icons.bed,
        Icons.chair,
        Icons.kitchen,
        Icons.bathtub,
        Icons.desk,
        Icons.business_center
      ];

  List<Widget> _getIconItems(FormFieldState<IconData> state) => _getIcons()
      .map((e) => IconButton(
            icon: Icon(
              e,
              color: state.value == e ? Theme.of(context).primaryColor : null,
            ),
            onPressed: () => setState(() {
              state.didChange(e);
            }),
          ))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) => CustomDialog(
          title: AppLocalizations.of(context)!.environment_addition_title,
          content: FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
              },
              child: Column(
                children: [
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'name',
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: AppLocalizations.of(context)!
                          .environment_addition_name,
                      suffixIcon: _nameHasError
                          ? Icon(Icons.error,
                              color: Theme.of(context).colorScheme.error)
                          : const Icon(Icons.check, color: Colors.green),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _nameHasError = !(_formKey.currentState?.fields['name']
                                ?.validate() ??
                            false);
                      });
                    },
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    textInputAction: TextInputAction.next,
                  ),
                  Focus(child: Builder(builder: (BuildContext context) {
                    final FocusNode focusNode = Focus.of(context);
                    final bool hasFocus = focusNode.hasFocus;

                    return GestureDetector(
                        onTap: () {
                          if (hasFocus) {
                            focusNode.unfocus();
                          } else {
                            focusNode.requestFocus();
                          }
                        },
                        child: FormBuilderField<IconData>(
                          autovalidateMode: AutovalidateMode.always,
                          name: 'icon',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          builder: (FormFieldState<IconData> state) {
                            return Column(children: [
                              InputDecorator(
                                  decoration: InputDecoration(
                                    border: const UnderlineInputBorder(),
                                    labelText: AppLocalizations.of(context)!
                                        .environment_addition_icon,
                                    suffixIcon: _iconHasError
                                        ? Icon(Icons.error,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  isEmpty: state.value == null,
                                  isFocused: hasFocus,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (state.value != null)
                                          ? Icon(state.value!)
                                          : Container(),
                                      const Icon(Icons.expand_more_rounded)
                                    ],
                                  )),
                              if (hasFocus)
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 10,
                                      children: _getIconItems(state),
                                    ),
                                  ),
                                )
                            ]);
                          },
                          onChanged: (val) {
                            setState(() {
                              _iconHasError = !(_formKey
                                      .currentState?.fields['icon']
                                      ?.validate() ??
                                  false);
                            });
                          },
                        ));
                  }))
                ],
              )),
          actions: [
            TextButton(
                onPressed: _formKey.currentState != null &&
                        _formKey.currentState!.validate()
                    ? () async {
                        await BlocProvider.of<EnvironmentsCubit>(context)
                            .addEnvironment(
                                name: _formKey.currentState!.value["name"],
                                icon: _formKey.currentState!.value["icon"])
                            .whenComplete(() {
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    : null,
                child: Text(AppLocalizations.of(context)!.ok)),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel))
          ]);
}
