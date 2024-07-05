import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_locker/constants.dart';

class MyCustomWidgets {
  bool _isPasswordVisible = false;

  TextField textFieldMethod(
      String hint,
      IconData icon,
      TextInputType keyboardType,
      bool obscure,
      isPassword,
      String variable,
      List<TextInputFormatter>? inputFormatters) {
    return TextField(
      onChanged: (value){
        variable = value;
      },
      cursorColor: kTextColor,
      obscureText: obscure,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: kTextColor, width: 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kTextColor, width: 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: "Amiri",
          fontWeight: FontWeight.bold,
          color: kTextColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  _isPasswordVisible = !_isPasswordVisible;
                },
                color: Colors.grey,
              )
            : Icon(
                icon,
                color: Colors.grey,
              ),
      ),
    );
  }

  Text textMethod(String text, Color color, double fontSize, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Amiri",
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  Container containerMethod(IconData icon, String lockerNumber, String lockerType, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          textMethod(lockerNumber.toString(), Colors.black, 20.0, true),
          textMethod(lockerType, color, 18.0, true),
        ],
      ),
    );
  }

  Container cardMethod(IconData rightIcon, String lockerNumber, String bookedAt, IconData leftIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 1.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          //for info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon( rightIcon, size: 25.0, color: Colors.black,),
                  textMethod(lockerNumber.toString(), Colors.black, 18.0, true),
                ],
              ),
               Icon(leftIcon,size: 25.0,color: Colors.black,),
            ],
          ),
          const SizedBox(height: 5.0,),
          // for date
          Row(
            children: [
              textMethod("Booked At:$bookedAt", Colors.black, 14.0, true),
            ],
          ),
        ],
      ),
    );
  }
}
