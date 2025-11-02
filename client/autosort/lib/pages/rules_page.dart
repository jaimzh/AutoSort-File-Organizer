import 'package:autosort/constants.dart';
import 'package:autosort/models/rule.dart';
import 'package:autosort/services/api_service.dart';
import 'package:autosort/theme.dart';
import 'package:autosort/widgets/AddExceptionDialog.dart';
import 'package:autosort/widgets/addRuleDialog.dart';
import 'package:autosort/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// ----------------- RulesPage -----------------
class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rules',
            style: TextStyle(
              fontSize: AppFontSizes.kPageTitle,
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: RulesContainer()),
          SizedBox(height: 20),

          ExceptionsContainer(),
        ],
      ),
    );
  }
}

class ExceptionsContainer extends StatefulWidget {
  const ExceptionsContainer({super.key});

  @override
  State<ExceptionsContainer> createState() => _ExceptionsContainerState();
}

class _ExceptionsContainerState extends State<ExceptionsContainer> {
  late Future<List<String>?> _exceptionFuture;

  @override
  void initState() {
    super.initState();
    _exceptionFuture = ApiService.getExceptions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.x, color: AppColors.primaryText),
                  SizedBox(width: 10),
                  Text(
                    "Exceptions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 22,
                  color: AppColors.iconColor,
                ),
                tooltip: "Add Exception",

                onPressed: () async {
                  final currentExceptions = await ApiService.getExceptions();

                  if (!mounted) return;

                  _showAddExceptionDialog(currentExceptions ?? []);
                }, // disabled for now
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: _exceptionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error loading rules: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "No rules added yet",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                );
              }
              final exceptionData = snapshot.data!;

              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: exceptionData
                    .map(
                      (ext) => Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pill,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          ext,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddExceptionDialog(List<String> initialExtensions) {
    showDialog(
      context: context,
      builder: (context) {
        return AddExceptionDialog(
          initialExtensions: initialExtensions,
          onSave: (List<String> extensions) async {
            final updated = await ApiService.updateExceptions(extensions);

            if (updated != null) {
              print("✅ Updated exceptions: $updated");
              setState(() {
                _exceptionFuture = ApiService.getExceptions();
              }); // refresh UI
            } else {
              print("❌ Failed to update exception");
            }
          },
        );
      },
    );
  }
}

// ----------------- RulesContainer -----------------
class RulesContainer extends StatefulWidget {
  const RulesContainer({super.key});

  @override
  State<RulesContainer> createState() => _RulesContainerState();
}

class _RulesContainerState extends State<RulesContainer> {
  Future<List<Map<String, dynamic>>> fetchRules() async {
    final config = await ApiService.getConfig();

    if (config != null) {
      final rulesMap = config['rules'] as Map<String, dynamic>;
      final rulesList = rulesMap.entries
          .where((entry) => entry.key != 'Others')
          .map((entry) {
            return {
              'category': entry.key,
              'extension': List<String>.from(entry.value),
            };
          })
          .toList();

      return rulesList;
    } else {
      print('no rules found man ');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.scroll, color: AppColors.iconColor),
                  SizedBox(width: 10),
                  Text(
                    "Folder Rules",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.kBodyText,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.code, size: 22),
                  //   tooltip: "Edit Config",
                  //   onPressed: () {},
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 22,
                      color: AppColors.iconColor,
                    ),
                    tooltip: "Add Rule",
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddRuleDialog(
                            onSave: (category, extensions) async {
                              final config = await ApiService.getConfig();
                              if (config == null) return;
                              final rules = Map<String, dynamic>.from(
                                config['rules'],
                              );
                              rules[category] = extensions;
                              final updatedConfig = {...config, 'rules': rules};
                              await ApiService.updateConfigWithRules(
                                updatedConfig,
                              );
                              // await ApiService.updateConfigWithRules({'rules': rules});
                              setState(() {});
                            },
                          );
                        },
                      );
                    }, // disabled for now
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchRules(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error loading rules: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "No rules added yet",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  );
                }
                final rulesData = snapshot.data!;

                return (ListView.separated(
                  separatorBuilder: (_, _) => SizedBox(height: 10),
                  itemCount: rulesData.length,
                  itemBuilder: ((context, index) {
                    final ruleMap = rulesData[index];
                    final rule = Rule.fromMap(
                      ruleMap['category'],
                      ruleMap['extension'],
                    );
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RuleCard(
                        rule: rule,
                        onDelete: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              constraints: BoxConstraints.tight(Size(300, 220)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                              title: const Text('Delete Confirmation'),
                              content: Text(
                                'Are you sure you want to delete "${rule.category}"?',
                              ),
                              actions: [
                                CustomButton(
                                  text: 'Cancel',
                                  textColor: AppColors.buttonText,
                                  hoverColor: AppColors.buttonHover,
                                  onPressed: () => {
                                    Navigator.of(context).pop(false),
                                  },
                                ),
                                CustomButton(
                                  text: 'Delete',
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },

                                  backgroundColor: AppColors.deleteBtn,
                                  hoverColor: AppColors.deleteBtnHover,
                                  textColor: AppColors.buttonText,
                                  borderColor: AppColors.deleteBtnHover,
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await ApiService.deleteCategory(rule.category);
                            final config = await ApiService.getConfig();
                            if (config == null) return;
                            final rules = Map.from(config['rules']);
                            rules.remove(rule.category);
                            setState(() {});
                          }
                        },

                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AddRuleDialog(
                                initialCategory: rule.category,
                                initialExtensions: rule.extensions,
                                onSave: (newCategory, newExtensions) async {
                                  final config = await ApiService.getConfig();
                                  if (config == null) return;

                                  final rules = Map<String, dynamic>.from(
                                    config['rules'],
                                  );
                                  if (newCategory != rule.category) {
                                    rules.remove(rule.category);
                                  }
                                  rules[newCategory] = newExtensions;
                                  final updatedConfig = {
                                    ...config,
                                    'rules': rules,
                                  };
                                  await ApiService.updateConfigWithRules(
                                    updatedConfig,
                                  );

                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final Rule rule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const RuleCard({
    super.key,
    required this.rule,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case "Documents":
        return LucideIcons.fileText;
      case "Images":
        return LucideIcons.image;
      case "Videos":
        return LucideIcons.video;
      case "Audio":
        return LucideIcons.music;
      case "Archives":
        return LucideIcons.archive;
      default:
        return LucideIcons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getIcon(rule.category),
                    size: 20,
                    color: AppColors.iconColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    rule.category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.iconColor,
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: AppColors.iconColor,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: rule.extensions
                .map(
                  (ext) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pill,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ext,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
