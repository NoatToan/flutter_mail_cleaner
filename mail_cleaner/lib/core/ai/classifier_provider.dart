import 'package:ai_smart_mail/core/ai/mail_classifier.dart';
import 'package:ai_smart_mail/core/ai/rule_mail_classifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classifier_provider.g.dart';

@Riverpod(keepAlive: true)
MailClassifier mailClassifier(Ref ref) => RuleMailClassifier();
