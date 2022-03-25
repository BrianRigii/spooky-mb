library add_ons_view;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/product_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/providers/google_pay_provider.dart';
import 'package:spooky/providers/user_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/widgets/sp_add_on_visibility.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_developer_visibility.dart';
import 'package:spooky/widgets/sp_expanded_app_bar.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/views/add_ons/add_ons_view_model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

part 'add_ons_mobile.dart';
part 'add_ons_tablet.dart';
part 'add_ons_desktop.dart';

class AddOnsView extends StatelessWidget {
  const AddOnsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddOnsViewModel>(
      create: (_) => AddOnsViewModel(context),
      onModelReady: (context, provider) {
        context.read<GooglePayProvider>().fetchProducts();
      },
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _AddOnsMobile(viewModel),
          desktop: _AddOnsDesktop(viewModel),
          tablet: _AddOnsTablet(viewModel),
        );
      },
    );
  }
}