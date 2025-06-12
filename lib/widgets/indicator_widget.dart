import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.prossess,
    required this.count,
  });

  final int prossess;
  final int count;

  @override
  Widget build(BuildContext context) {
    assert(
      prossess >= 0 && prossess < count,
      'Prossess must be between 0 and $count',
    );

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(100),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          spacing: 10,
          children: [
            for (int i = 0; i < 3; i++)
              Expanded(
                flex: 1,
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        prossess >= i
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(100),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
