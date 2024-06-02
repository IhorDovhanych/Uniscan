import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniscan/application/di/injections.dart';
import 'package:uniscan/application/domain/entities/qr_code_entity.dart';
import 'package:uniscan/application/presentation/features/main/features/home/widgets/qr_code/cubit/qr_code_cubit.dart';
import 'package:uniscan/application/presentation/widgets/loading/loading_view_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeDialog extends StatelessWidget {
  const QrCodeDialog({
    final Key? key,
    this.qrCode,
    this.url,
  }) : super(key: key);

  final QrCodeEntity? qrCode;
  final String? url;

  bool get _isAdding => qrCode == null;

  static void show(
    final BuildContext context, {
    final QrCodeEntity? qrCode,
    final String? url,
  }) {
    showDialog(
      context: context,
      builder: (final context) => QrCodeDialog(
        qrCode: qrCode,
        url: url,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => getIt<QrCodeCubit>()..init(qrCode, url),
        child: MultiBlocListener(
          listeners: [
            BlocListener<QrCodeCubit, QrCodeState>(
              listenWhen: (final previous, final current) => previous.success != current.success,
              listener: (final context, final state) {
                if (state.success) {
                  Navigator.of(context).pop();
                }
              },
            ),
            BlocListener<QrCodeCubit, QrCodeState>(
              listenWhen: (final previous, final current) => previous.error != current.error,
              listener: (final context, final state) {
                if (state.error != null) {
                  showDialog(
                      context: context,
                      builder: (final context) => AlertDialog(
                            content: Text(state.error.toString()),
                          ));
                }
              },
            ),
          ],
          child: BlocBuilder<QrCodeCubit, QrCodeState>(
            builder: (final context, final state) => AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              content: LoadingViewWidget(
                isLoading: state.isLoading,
                child: Column(
                  children: [
                    Text(
                      _isAdding ? 'Add QR Code' : 'Edit QR Code',
                      style: const TextStyle(fontSize: 20),
                    ),
                    CustomInputField(
                      valueText: state.qrCode.name,
                      labelText: 'Name',
                      hintText: 'QR code name',
                      onTextChanged: context.read<QrCodeCubit>().onChangeName,
                    ),
                    CustomInputField(
                      valueText: state.qrCode.url,
                      labelText: 'URL',
                      hintText: 'https://example.com',
                      onTextChanged: context.read<QrCodeCubit>().onChangeUrl,
                    ),
                  ],
                ),
              ),
              actions: [
                (url == null)
                    ? ElevatedButton(
                        onPressed: () {
                          if (_isAdding) {
                            context.read<QrCodeCubit>().addQrCode();
                          } else {
                            context.read<QrCodeCubit>().updateQrCode();
                          }
                        },
                        child: _isAdding
                            ? Text(
                                'Add',
                                style: TextStyle(color: Colors.black),
                              )
                            : const Text(
                                'Update',
                                style: TextStyle(color: Colors.black), // Customize color for update
                              ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                context.read<QrCodeCubit>().addQrCode();
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.black),
                              )),
                          ElevatedButton(
                            onPressed: () {
                              context.read<QrCodeCubit>().addQrCode();
                              launchUrl(Uri.parse(state.qrCode.url));
                            },
                            child: const Text(
                              'Add and visit',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      );
}

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    required this.labelText,
    this.onTextChanged,
    this.valueText = '',
    this.hintText,
  });

  final ValueChanged<String>? onTextChanged;
  final String labelText;
  final String valueText;
  final String? hintText;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    if (widget.valueText.isNotEmpty) {
      _textEditingController.text = widget.valueText;
    }
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void didUpdateWidget(covariant final CustomInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((_textEditingController.text.isEmpty && widget.valueText.isNotEmpty) ||
        (_textEditingController.text != widget.valueText)) {
      _textEditingController.text = widget.valueText;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        onChanged: widget.onTextChanged,
        minLines: 1,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
        ),
      );
}
