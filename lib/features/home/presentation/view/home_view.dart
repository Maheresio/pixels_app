import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/bloc/photo_bloc.dart';
import '../widgets/home_view_body.dart';
import '../widgets/logout_floating_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController scrollController;
  late final TextEditingController searchController;
  Timer? _debounce;
  String? selectedOrientation;
  String? selectedSize;
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    searchController = TextEditingController();
    scrollController.addListener(() {
      _onScroll();
    });
    context.read<PhotoBloc>().add(const GetPhotosEvent());
  }

  void _onScroll() {
    final position = scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      context.read<PhotoBloc>().add(const GetPhotosEvent());
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeViewBody(
        scrollController: scrollController,
        searchController: searchController,
        selectedOrientation: selectedOrientation,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
        onFilterApplied: _onFilterApplied,
      ),
      floatingActionButton: const LogoutFloatingButton(),
    );
  }

  void _onFilterApplied(String? orientation, String? size, String? color) {
    setState(() {
      selectedOrientation = orientation;
      selectedSize = size;
      selectedColor = color;
    });
  }
}
