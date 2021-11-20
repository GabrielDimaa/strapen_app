import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strapen_app/app/shared/apis/cep_api.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/components/form/validator.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/text_input/text_input_default.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class TextFieldEndereco extends StatefulWidget {
  final Function(String?)? onSavedCep;
  final Function(String?)? onSavedCidade;
  final String? cep;
  final String? cidade;

  TextFieldEndereco({
    this.onSavedCep,
    this.onSavedCidade,
    this.cep,
    this.cidade,
  });

  final _TextFieldEnderecoState _widgetState = _TextFieldEnderecoState();

  @override
  State<TextFieldEndereco> createState() => _widgetState;

  GlobalKey<FormState> get formKey => _widgetState._formKey;

  bool get cepValid => _widgetState._cepValid;

  void unFocus() {
    _widgetState._unFocus();
  }
}

class _TextFieldEnderecoState extends State<TextFieldEndereco> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _cepFocus = FocusNode();
  final FocusNode _cidadeFocus = FocusNode();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  bool _cepValid = true;
  String _cidade = "";

  @override
  void initState() {
    super.initState();

    _cepController.text = widget.cep ?? "";
    _cidadeController.text = widget.cidade ?? "";
    _cidade = widget.cidade ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecorationDefault(
              labelText: "CEP",
            ),
            controller: _cepController,
            keyboardType: TextInputType.number,
            validator: InputCepValidator().validate,
            textInputAction: TextInputAction.done,
            focusNode: _cepFocus,
            onFieldSubmitted: (_) => _cepFocus.unfocus(),
            onChanged: (String? value) async {
              String cep = value.extrairNum();
              if (cep.length == 8) await getCep(cep);
            },
            onSaved: widget.onSavedCep,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
          ),
          const VerticalSizedBox(2),
          TextFormField(
            decoration: InputDecorationDefault(labelText: "Cidade"),
            controller: _cidadeController,
            validator: InputValidatorDefault().validate,
            textCapitalization: TextCapitalization.sentences,
            onSaved: widget.onSavedCidade,
            textInputAction: TextInputAction.done,
            focusNode: _cidadeFocus,
            onFieldSubmitted: (_) => _cidadeFocus.unfocus(),
            onChanged: (String? value) {
              if (_cidade != value)
                _cepController.clear();
            },
          ),
        ],
      ),
    );
  }

  Future<void> getCep(String cep) async {
    try {
      _cepValid = true;
      _cepFocus.unfocus();

      await LoadingDialog.show(context, "Buscando CEP...", () async {
        final Map<String, dynamic>? response = await CepApi.get("$cep/json");

        if (response != null) {
          _cidadeController.text = response['localidade'];
          _cidade = _cidadeController.text;
        }
      });
    } catch (e) {
      _cepValid = false;
      _cidadeController.clear();
      await ErrorDialog.show(context: context, content: e.toString());
    }
  }

  void _unFocus() {
    _cepFocus.unfocus();
    _cidadeFocus.unfocus();
  }
}
