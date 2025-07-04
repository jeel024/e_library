import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/logic_bloc/logic_bloc.dart';
import '../../bloc/logic_bloc/logic_event.dart';
import '../../bloc/logic_bloc/logic_state.dart';


pass_textfield(TextEditingController controller, String hint) {
  return BlocBuilder<LogicBloc, LogicState>(
    builder: (context, state) {
      bool temp = BlocProvider.of<LogicBloc>(context).eye;
      return TextField(
        controller: controller,
        obscureText: temp,
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20*4),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                BlocProvider.of<LogicBloc>(context).add(Eye(temp));
              },
              icon: Icon((temp) ? Icons.visibility : Icons.visibility_off),
            ),
            filled: true,
            fillColor: Colors.orange.withOpacity(0.2),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 3, color: Colors.orange.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 3, color: Colors.orange.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10)),
            hintText: hint),
      );
    },
  );
}

email_textfield(TextEditingController controller, String hint) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.orange.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Colors.orange.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Colors.orange.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10)),
        hintText: hint),
  );
}
