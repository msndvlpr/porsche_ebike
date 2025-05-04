part of 'theme_cubit.dart';

final class ThemeState extends Equatable {
  const ThemeState({
    required this.isDark
  });

  final bool isDark;

  @override
  List<Object> get props => [isDark];
}