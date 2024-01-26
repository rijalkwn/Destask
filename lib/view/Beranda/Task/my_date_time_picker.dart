import 'package:flutter/material.dart';

class MyDateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;

  MyDateTimePicker({
    required this.selectedDate,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? '${selectedDate!.toLocal()}'.split(' ')[0]
            : 'No date selected',
      ),
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (validator != null) {
          return validator!(selectedDate);
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      onChanged(pickedDate);
    }
  }
}
