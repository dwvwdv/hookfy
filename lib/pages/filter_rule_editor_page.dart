import 'package:flutter/material.dart';
import '../models/filter_condition.dart';

/// 過濾規則編輯器頁面
class FilterRuleEditorPage extends StatefulWidget {
  final FilterRule rule;
  final String appName;
  final Function(FilterRule) onSave;

  const FilterRuleEditorPage({
    super.key,
    required this.rule,
    required this.appName,
    required this.onSave,
  });

  @override
  State<FilterRuleEditorPage> createState() => _FilterRuleEditorPageState();
}

class _FilterRuleEditorPageState extends State<FilterRuleEditorPage> {
  late TextEditingController _nameController;
  late List<FilterCondition> _conditions;
  late List<PlaceholderExtractor> _extractors;

  final List<String> _fieldOptions = [
    'title',
    'text',
    'bigText',
    'subText',
    'appName',
    'packageName',
  ];

  final Map<String, String> _fieldLabels = {
    'title': '標題',
    'text': '內容',
    'bigText': '完整內容',
    'subText': '副標題',
    'appName': '應用名稱',
    'packageName': '包名',
  };

  final List<String> _operatorOptions = [
    'contains',
    'notContains',
    'equals',
    'notEquals',
    'startsWith',
    'endsWith',
    'matches',
  ];

  final Map<String, String> _operatorLabels = {
    'contains': '包含',
    'notContains': '不包含',
    'equals': '等於',
    'notEquals': '不等於',
    'startsWith': '開頭是',
    'endsWith': '結尾是',
    'matches': '匹配（正則）',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.rule.name);
    _conditions = List.from(widget.rule.conditions);
    _extractors = List.from(widget.rule.extractors);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveRule() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入規則名稱')),
      );
      return;
    }

    final updatedRule = widget.rule.copyWith(
      name: _nameController.text.trim(),
      conditions: _conditions,
      extractors: _extractors,
    );

    widget.onSave(updatedRule);
    Navigator.pop(context);
  }

  void _addCondition() {
    showDialog(
      context: context,
      builder: (context) => _ConditionEditorDialog(
        onSave: (condition) {
          setState(() {
            _conditions.add(condition);
          });
        },
        fieldOptions: _fieldOptions,
        fieldLabels: _fieldLabels,
        operatorOptions: _operatorOptions,
        operatorLabels: _operatorLabels,
      ),
    );
  }

  void _editCondition(int index) {
    showDialog(
      context: context,
      builder: (context) => _ConditionEditorDialog(
        condition: _conditions[index],
        onSave: (condition) {
          setState(() {
            _conditions[index] = condition;
          });
        },
        fieldOptions: _fieldOptions,
        fieldLabels: _fieldLabels,
        operatorOptions: _operatorOptions,
        operatorLabels: _operatorLabels,
      ),
    );
  }

  void _deleteCondition(int index) {
    setState(() {
      _conditions.removeAt(index);
    });
  }

  void _addExtractor() {
    showDialog(
      context: context,
      builder: (context) => _ExtractorEditorDialog(
        onSave: (extractor) {
          setState(() {
            _extractors.add(extractor);
          });
        },
        fieldOptions: _fieldOptions,
        fieldLabels: _fieldLabels,
      ),
    );
  }

  void _editExtractor(int index) {
    showDialog(
      context: context,
      builder: (context) => _ExtractorEditorDialog(
        extractor: _extractors[index],
        onSave: (extractor) {
          setState(() {
            _extractors[index] = extractor;
          });
        },
        fieldOptions: _fieldOptions,
        fieldLabels: _fieldLabels,
      ),
    );
  }

  void _deleteExtractor(int index) {
    setState(() {
      _extractors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('編輯規則 - ${widget.appName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRule,
            tooltip: '儲存',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 規則名稱
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '規則名稱',
              hintText: '例如：幣安儲值通知',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // 條件列表
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '匹配條件',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _addCondition,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '所有條件必須同時滿足（AND 邏輯）才會觸發此規則',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (_conditions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('尚無條件，點擊上方「添加」按鈕新增'),
                ),
              ),
            )
          else
            ..._conditions.asMap().entries.map((entry) {
              final index = entry.key;
              final condition = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${_fieldLabels[condition.field]} ${_operatorLabels[condition.operator]} "${condition.value}"',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editCondition(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () => _deleteCondition(index),
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 24),

          // 提取器列表
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Placeholder 提取器',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _addExtractor,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '從通知內容中提取特定資訊，結果會包含在 webhook payload 的 extractedFields 中',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (_extractors.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('尚無提取器，點擊上方「添加」按鈕新增'),
                ),
              ),
            )
          else
            ..._extractors.asMap().entries.map((entry) {
              final index = entry.key;
              final extractor = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('提取 ${extractor.name}'),
                  subtitle: Text(
                    '從 ${_fieldLabels[extractor.sourceField]} 用正則 "${extractor.pattern}" 提取',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editExtractor(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () => _deleteExtractor(index),
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// 條件編輯對話框
class _ConditionEditorDialog extends StatefulWidget {
  final FilterCondition? condition;
  final Function(FilterCondition) onSave;
  final List<String> fieldOptions;
  final Map<String, String> fieldLabels;
  final List<String> operatorOptions;
  final Map<String, String> operatorLabels;

  const _ConditionEditorDialog({
    this.condition,
    required this.onSave,
    required this.fieldOptions,
    required this.fieldLabels,
    required this.operatorOptions,
    required this.operatorLabels,
  });

  @override
  State<_ConditionEditorDialog> createState() => _ConditionEditorDialogState();
}

class _ConditionEditorDialogState extends State<_ConditionEditorDialog> {
  late String _selectedField;
  late String _selectedOperator;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _selectedField = widget.condition?.field ?? widget.fieldOptions.first;
    _selectedOperator = widget.condition?.operator ?? widget.operatorOptions.first;
    _valueController = TextEditingController(text: widget.condition?.value ?? '');
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.condition == null ? '添加條件' : '編輯條件'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('字段', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedField,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: widget.fieldOptions.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(widget.fieldLabels[field] ?? field),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedField = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('運算符', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: widget.operatorOptions.map((op) {
                return DropdownMenuItem(
                  value: op,
                  child: Text(widget.operatorLabels[op] ?? op),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedOperator = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('值', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _selectedOperator == 'matches' ? '正則表達式' : '匹配的值',
              ),
              maxLines: _selectedOperator == 'matches' ? 3 : 1,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_valueController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請輸入值')),
              );
              return;
            }

            final condition = FilterCondition(
              field: _selectedField,
              operator: _selectedOperator,
              value: _valueController.text.trim(),
            );

            widget.onSave(condition);
            Navigator.pop(context);
          },
          child: const Text('確定'),
        ),
      ],
    );
  }
}

/// 提取器編輯對話框
class _ExtractorEditorDialog extends StatefulWidget {
  final PlaceholderExtractor? extractor;
  final Function(PlaceholderExtractor) onSave;
  final List<String> fieldOptions;
  final Map<String, String> fieldLabels;

  const _ExtractorEditorDialog({
    this.extractor,
    required this.onSave,
    required this.fieldOptions,
    required this.fieldLabels,
  });

  @override
  State<_ExtractorEditorDialog> createState() => _ExtractorEditorDialogState();
}

class _ExtractorEditorDialogState extends State<_ExtractorEditorDialog> {
  late TextEditingController _nameController;
  late String _selectedField;
  late TextEditingController _patternController;
  late TextEditingController _groupController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.extractor?.name ?? '');
    _selectedField = widget.extractor?.sourceField ?? widget.fieldOptions.first;
    _patternController = TextEditingController(text: widget.extractor?.pattern ?? '');
    _groupController = TextEditingController(text: '${widget.extractor?.group ?? 1}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _patternController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.extractor == null ? '添加提取器' : '編輯提取器'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('名稱', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '例如：amount、currency',
              ),
            ),
            const SizedBox(height: 16),
            const Text('來源字段', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedField,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: widget.fieldOptions.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(widget.fieldLabels[field] ?? field),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedField = value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('正則表達式', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _patternController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: r'例如：(\d+\.?\d*)(USDT|BTC)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            const Text(
              '使用括號 () 來捕獲想提取的內容',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text('捕獲組索引', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _groupController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '1',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            const Text(
              '0 = 整個匹配，1 = 第一個括號，2 = 第二個括號...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請輸入名稱')),
              );
              return;
            }

            if (_patternController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請輸入正則表達式')),
              );
              return;
            }

            final group = int.tryParse(_groupController.text.trim()) ?? 1;

            final extractor = PlaceholderExtractor(
              name: _nameController.text.trim(),
              sourceField: _selectedField,
              pattern: _patternController.text.trim(),
              group: group,
            );

            widget.onSave(extractor);
            Navigator.pop(context);
          },
          child: const Text('確定'),
        ),
      ],
    );
  }
}
