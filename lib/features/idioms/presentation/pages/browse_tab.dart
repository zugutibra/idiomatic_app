import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';
import 'package:idiomatic_app/features/idioms/presentation/bloc/browse_cubit.dart';
import 'package:idiomatic_app/features/idioms/presentation/bloc/browse_state.dart';
import 'package:idiomatic_app/features/review/presentation/pages/review_page.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return BlocBuilder<BrowseCubit, BrowseState>(
      builder: (context, state) {
        if (state.status == BrowseStatus.loading || state.status == BrowseStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == BrowseStatus.error) {
          return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Browse Topics', style: AppTheme.serifItalic(context, size: 26)),
                  if (state.isRefreshing)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: colors.textTertiary),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text('Explore idioms by category, anytime.', style: TextStyle(fontSize: 13, color: colors.textSecondary)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.topics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, i) {
                  final topic = state.topics[i];
                  final def = TopicDef.byId(topic.id);
                  return Material(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ReviewPage(topic: topic.id)))
                          .then((_) {
                            if (context.mounted) context.read<BrowseCubit>().load();
                          }),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: colors.primarySoft, borderRadius: BorderRadius.circular(11)),
                              child: Icon(def.icon, size: 18, color: colors.primary),
                            ),
                            const SizedBox(height: 9),
                            Text(topic.label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.text)),
                            const SizedBox(height: 2),
                            Text('${topic.count} idioms', style: TextStyle(fontSize: 11.5, color: colors.textSecondary)),
                            const SizedBox(height: 9),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: topic.pct / 100,
                                minHeight: 5,
                                backgroundColor: colors.surfaceAlt,
                                valueColor: AlwaysStoppedAnimation(colors.success),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
