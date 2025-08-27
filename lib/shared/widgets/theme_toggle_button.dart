import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget{
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(), 
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: child.key == const ValueKey('light')
                ? Tween<double>(begin: 1, end: 0.75).animate(animation)
                : Tween<double>(begin: 0.75, end: 1).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.light
                ? Icons.wb_sunny
                : Icons.nights_stay,
              key: ValueKey(context.watch<ThemeCubit>().state),
            ),
          )
        );
      }
    );
  }
}