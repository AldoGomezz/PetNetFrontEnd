import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/history/presentation/presentation.dart';

class TopBarHistorias extends ConsumerWidget {
  const TopBarHistorias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    //final colorScheme = Theme.of(context).colorScheme;

    double withSearchBar = size.width * 0.8;

    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
    );
    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20),
    );

    final items = SearchType.values.map((searchType) {
      return DropdownMenuItem(
        value: searchType,
        child: Text(capitalize(searchType.name)),
      );
    }).toList();

    return FittedBox(
      child: Container(
        height: size.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
          color: ColorsCustom.searchBar,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchTextField(context, ref, size, withSearchBar),
            _buildDropDownButton(
              context,
              ref,
              size,
              items,
              border,
              borderRadius,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropDownButton(
    BuildContext context,
    WidgetRef ref,
    Size size,
    List<DropdownMenuItem> items,
    OutlineInputBorder border,
    BorderRadius borderRadius,
  ) {
    return SizedBox(
      width: size.width * 0.3,
      child: Center(
        child: CustomDropDownButton(
          hintText: "Seleccione",
          titleStyle: getSubtitleStyle(context),
          borderRadius: borderRadius,
          borde: border,
          items: items,
          initialValue: SearchType.patient,
          onChanged: (value) {
            ref
                .read(historySearchBarProvider.notifier)
                .onSearchTypeChange(value);
          },
        ),
      ),
    );
  }

  Widget _buildSearchTextField(
    BuildContext context,
    WidgetRef ref,
    Size size,
    double withSearchBar,
  ) {
    Timer? debounce;
    return Container(
      height: double.maxFinite,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: withSearchBar,
          child: CustomBarTextFormField(
            hint: "Buscar...",
            style: getTitleStyle(context),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            onChanged: (p0) {
              if (debounce?.isActive ?? false) debounce!.cancel();
              debounce = Timer(const Duration(milliseconds: 550), () {
                ref
                    .read(historySearchBarProvider.notifier)
                    .onSearchBarChange(p0);
              });
            },
            onFieldSubmitted: (p0) {},
          ),
        ),
      ),
    );
  }
}
