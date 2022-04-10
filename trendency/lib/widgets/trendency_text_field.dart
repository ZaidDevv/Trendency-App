import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../consts/app_colors.dart';

class TrendencyTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isRequired;
  final double width;
  final bool hidden;
  final ValueSetter<String?> callback;

  const TrendencyTextField(
      {Key? key,
      required this.hint,
      required this.icon,
      this.hidden = false,
      required this.width,
      required this.callback,
      required this.isRequired})
      : super(key: key);

  @override
  State<TrendencyTextField> createState() => _TrendencyTextFieldState();
}

class _TrendencyTextFieldState extends State<TrendencyTextField> {
  bool? _passwordVisible;
  bool? _clearTextVisible;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = widget.hidden;
    _clearTextVisible = false;
  }

  Widget? getIconType(bool passwordVisible, bool clearTextVisible) {
    if (clearTextVisible && !widget.hidden) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          setState(() {
            _clearTextVisible = false;
          });
        },
        icon: Icon(
          Icons.close,
          color: Theme.of(context).primaryColorDark,
        ),
      );
    } else if (widget.hint.toLowerCase() == "password") {
      return IconButton(
        onPressed: () => setState(() {
          _passwordVisible = !_passwordVisible!;
        }),
        icon: Icon(
          _passwordVisible! ? Icons.visibility_off : Icons.visibility,
          color: Theme.of(context).primaryColorDark,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
        controller: _controller,
        onChanged: (val) {
          if (val.isNotEmpty) {
            setState(() {
              _clearTextVisible = true;
            });
          } else {
            setState(() {
              _clearTextVisible = false;
            });
          }
        },
        textInputAction: TextInputAction.next,
        obscureText: _passwordVisible!,
        onSaved: widget.callback,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          suffixIcon: getIconType(_passwordVisible!, _clearTextVisible!),
          hintText: widget.hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColor.secondaryColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppColor.primaryAccent, width: 2)),
          icon: Icon(
            widget.icon,
            color: AppColor.secondaryColor,
            size: 21,
          ),
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w300),
        ),
        validator: (submitted) {
          if (submitted!.isEmpty && widget.isRequired) {
            return "Please make sure to fill the ${widget.hint}";
          } else if (widget.hint == "Email" &&
              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(submitted)) {
            return "Please make sure to provide a valid email address";
          } else if (widget.hint == "Password" && submitted.length < 8) {
            return "Your password must contain at least 8 characters";
          } else if (widget.hint == "Username" && submitted.length < 3) {
            return "Your username must contain at least 3 characters";
          }
          return null;
        },
      ),
    );
  }
}
