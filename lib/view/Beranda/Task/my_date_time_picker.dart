import 'package:flutter/material.dart';

class MyDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;
  final String? Function(DateTime?)? validator;

  MyDateTimePicker({
    required this.label,
    required this.selectedDate,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
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
        ),
      ],
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
