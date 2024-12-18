import 'package:notesy/res/res.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.editable = true,
    this.controller,
    this.isHidden = false,
  });

  final bool editable, isHidden;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return editable
        ? TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              fontSize: 16.sp,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              prefixIcon: Icon(
                IconlyBroken.search,
                size: 16.sp,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .color!
                    .withOpacity(0.5),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              color: Theme.of(context).cardColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                Icon(
                  IconlyBroken.search,
                  size: 16.sp,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.5),
                ),
                8.sW,
                Text(
                  isHidden ? 'Search Hidden Notes' : 'Search Notesy',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
  }
}
