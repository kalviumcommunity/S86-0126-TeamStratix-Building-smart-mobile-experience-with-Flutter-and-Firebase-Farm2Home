import 'package:flutter/material.dart';
import '../core/app_breakpoints.dart';

class FilterChipGroup extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;
  final ScrollController? scrollController;

  const FilterChipGroup({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: Colors.grey.shade200,
              selectedColor: Theme.of(context).primaryColor,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MultiSelectFilterChips extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;

  const MultiSelectFilterChips({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedOptions);
            if (selected) {
              newSelection.add(option);
            } else {
              newSelection.remove(option);
            }
            onChanged(newSelection);
          },
          backgroundColor: Colors.grey.shade200,
          selectedColor: Theme.of(context).primaryColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}

class DateRangeFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?> onChanged;

  const DateRangeFilter({
    super.key,
    this.startDate,
    this.endDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDateRange: startDate != null && endDate != null
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
        );
        
        onChanged(picked);
      },
      icon: const Icon(Icons.date_range),
      label: Text(
        startDate != null && endDate != null
            ? '${_formatDate(startDate!)} - ${_formatDate(endDate!)}'
            : 'Select Date Range',
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
