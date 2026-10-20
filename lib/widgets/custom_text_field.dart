import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appTheme.dart';
import '../utils/responsive.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textInputStyle;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? ontap;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? scrollPadding;
  final double? paddingV;
  final double? paddingH;

  const CustomTextField({
    super.key,
    this.ontap,
    this.hintText,
    this.hintStyle,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.readOnly = false,
    this.textInputStyle,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.borderColor,
    this.borderRadius,
    this.scrollPadding,
    this.bgColor,
    this.paddingV,
    this.paddingH,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with SingleTickerProviderStateMixin {
  String? _errorText;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animController;
  bool _tooltipVisible = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _hideTooltip();
    _animController.dispose();
    super.dispose();
  }

  void _hideTooltip() {
    _animController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _validate(String? value) {
    if (widget.validator == null) return;
    final error = widget.validator!(value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _errorText = error;
        // Hide tooltip if error is cleared
        if (error == null || error.isEmpty) {
          _tooltipVisible = false;
          _hideTooltip();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: (_errorText != null && _errorText!.isNotEmpty) ? 53.h : 50.h,
        padding: EdgeInsets.symmetric(horizontal: widget.paddingH ?? 5, vertical: widget.paddingV ?? 8),
        child: TextFormField(
          scrollPadding: widget.scrollPadding ?? EdgeInsets.zero,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: ThemeProvider.greenDarkColor,
          onFieldSubmitted: widget.onFieldSubmitted,
          textAlignVertical: TextAlignVertical.center,
          onTap: widget.ontap,
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validate(value);
          },
          keyboardType: widget.keyboardType,
          validator: (value) {
            final error = widget.validator?.call(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _errorText = error;
                if (error == null || error.isEmpty) {
                  _tooltipVisible = false;
                  _hideTooltip();
                }
              });
            });
            return error;
          },
          readOnly: widget.readOnly,
          style: widget.textInputStyle,
          inputFormatters: widget.inputFormatters ?? [],
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.bgColor ?? ThemeProvider.whiteColor,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_errorText != null && _errorText!.isNotEmpty)
                  Tooltip(
                    message: _errorText,
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: false,
                    // shows above the field
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'inter', fontWeight: FontWeight.w400),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Icon(Icons.error_outline, color: _tooltipVisible ? const Color(0xFFFF6B6B) : const Color(0xFFFF6B6B).withValues(alpha: 0.7), size: 20),
                  ),


                if (widget.suffixIcon != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: widget.suffixIcon),
              ],
            ),
            prefixIcon: widget.prefixIcon != null ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: widget.prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
              borderSide: const BorderSide(color: ThemeProvider.textFieldBorderColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
              borderSide: BorderSide(color: (_errorText != null && _errorText!.isNotEmpty) ? Colors.red : ThemeProvider.textFieldBorderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
              borderSide: BorderSide(color: (_errorText != null && _errorText!.isNotEmpty) ? Colors.red : ThemeProvider.textFieldBorderColor, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.all(5.0),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontFamily: 'inter',
              fontWeight: FontWeight.w500,
              color: ThemeProvider.textHintColor,
              fontSize: Responsive.responsiveFontSize(context, 12.sp),
            ),
            errorStyle: const TextStyle(fontSize: 0, height: 0),
          ),
        ),
      ),
    );
  }
}
