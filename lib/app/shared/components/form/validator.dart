import 'package:strapen_app/app/shared/extensions/string_extension.dart';

const String _messageErrorDefault = "Campo obrigatório!";

abstract class IInputValidator {
  String messageError();
  String? validate(String? value);
}

class InputValidatorDefault implements IInputValidator {
  final String? campo;

  InputValidatorDefault({this.campo});

  @override
  String messageError() => "";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    return null;
  }
}

class InputDateValidator implements IInputValidator {
  @override
  String messageError() => "Data inválida!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    List<String> dateSplit = value!.split("/");
    DateTime date = DateTime(int.parse(dateSplit[0]), int.parse(dateSplit[1]), int.parse(dateSplit[2]));

    if (!(date is DateTime)) return messageError();

    return null;
  }
}

class InputEmailValidator implements IInputValidator {
  @override
  String messageError() => "E-mail inválido!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
    if (!valid) return messageError();

    return null;
  }
}

class InputTelefoneValidator implements IInputValidator {
  @override
  String messageError() => "Número de telefone inválido!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    String telefone = value.extrairNum();

    if (telefone.length < 10 || telefone.length > 11)
      return messageError();

    return null;
  }
}

class InputCepValidator implements IInputValidator {
  @override
  String messageError() => "CEP inválido!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    String cep = value.extrairNum();

    if (cep.length != 8)
      return messageError();

    return null;
  }
}

class InputCpfCnpjValidator implements IInputValidator {
  bool isCnpj;
  InputCpfCnpjValidator({this.isCnpj = false});

  @override
  String messageError() => "${isCnpj ? "CNPJ" : "CPF"} inválido!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    String cpfCnpj = value.extrairNum();

    if (isCnpj && cpfCnpj.length != 14)
      return messageError();
    else if (!isCnpj && cpfCnpj.length != 11)
      return messageError();

    return null;
  }
}

class InputUserNameValidator implements IInputValidator {
  @override
  String messageError() => "Nome de usuário inválido!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    if (value!.length != value.trim().length)
      return "Não deve conter espaços!";

    if (value.contains("@"))
      return messageError();

    return null;
  }
}

class InputSenhaValidator implements IInputValidator {
  @override
  String messageError() => "Senha inválida!";

  @override
  String? validate(String? value) {
    if (value.isNullOrEmpty()) return _messageErrorDefault;

    if (value!.length < 8)
      return "A senha deve conter mais de 8 caracteres!";

    return null;
  }
}