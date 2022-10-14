import 'package:bookmyspot/constrains.dart';
import 'package:flutter/material.dart';


class BMSTextField extends StatelessWidget {
  BMSTextField({Key? key, this.label, this.hint, this.obscureText, this.controller, this.validator}) : super(key: key) {
    // controller = controller ?? TextEditingController();
  }
  String? label;
  String? hint;
  String? Function(String?)? validator;
  TextEditingController? controller;
  bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: this.label,
          hintText: this.hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(button_primary_color,),
              width: 2
            )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(button_primary_color)
            )
          )
        ),
      ),
    );
  }
}


class BMSPasswordField extends StatefulWidget {
  BMSPasswordField({Key? key, this.label, this.hint, this.controller, this.validator}) : super(key: key);
  String? label;
  String? hint;
  String? Function(String?)? validator;
  TextEditingController? controller;

  @override
  State<BMSPasswordField> createState() => _BMSPasswordFieldState();
}

class _BMSPasswordFieldState extends State<BMSPasswordField> {
  bool obs = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343,
      height: 56,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: obs,
        decoration: InputDecoration(
          isDense: true,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                obs = !obs;
              });

            },
            icon: Icon(obs? Icons.remove_red_eye_outlined: Icons.remove_red_eye),
          ),
            labelText: this.widget.label,
            // hintText: this.widget.hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Color(button_primary_color,),
                    width: 2
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Color(button_primary_color)
                )
            )
        ),
      ),
    );
  }
}
