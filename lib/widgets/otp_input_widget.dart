
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpInputWidget extends StatefulWidget {
  final int otpLength;
  final Function(String otp) onCompleted;
  final Function(String otp) onChange;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? textColor;
  final double? fieldWidth;
  final double? fieldHeight;

  const OtpInputWidget({
    super.key,
    this.otpLength = 6,
    required this.onCompleted,
    required this.onChange,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.textColor,
    this.fieldWidth,
    this.fieldHeight,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.otpLength, (_) => TextEditingController());
    focusNodes = List.generate(widget.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
  void _onChanged(String value, int index) {
    final otp = controllers.map((c) => c.text).join();
    if (value.length == 1) {
      if (index < widget.otpLength - 1) {
        focusNodes[index + 1].requestFocus();
        widget.onChange(otp);
      } else {
        focusNodes[index].unfocus();
        if (otp.length == widget.otpLength) {
          widget.onCompleted(otp);
        }
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
      widget.onChange(otp);
    }
  }

  /// Call this to clear all fields from outside
  void clearOtp() {
    for (var c in controllers) {
      c.clear();
    }
    focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6.w,
      children: List.generate(widget.otpLength, (index) {
        return SizedBox(
          width: widget.fieldWidth ?? 48,
          height: widget.fieldHeight ?? 56,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: widget.textColor ?? Colors.black,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? const Color(0xFF4A90E2),
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => _onChanged(value, index),
          ),
        );
      }),
    );
  }
}

