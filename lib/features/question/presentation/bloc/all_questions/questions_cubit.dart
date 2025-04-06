import 'package:dapple/features/question/domain/entities/objective_question.dart';
import 'package:dapple/features/question/domain/usecases/get_all_questions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_route_consts.dart';
import '../../../domain/entities/lesson.dart';
import '../../../domain/entities/subjective_question.dart';
import '../../../domain/entities/voice_question.dart';

part 'questions_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  final GetAllQuestions _getAllQuestions;

  QuestionsCubit({required GetAllQuestions getAllQuestions})
      : _getAllQuestions = getAllQuestions,
        super(QuestionsInitial());

  Future<int> loadQuestions(String sectionId) async {
    emit(QuestionsLoading());
    final res = await _getAllQuestions(sectionId);
    res.fold((l) {
      emit(QuestionsError(l.message));
    }, (r) {
      emit(QuestionsLoaded(r.questions, r.startIndex));
      return r.currentXp;
    });
    return 0;
  }

  void getNextQuestion(BuildContext context) {
    print((state as QuestionsLoaded).questions);
    print((state as QuestionsLoaded).currentIndex);
    if ((state as QuestionsLoaded).currentIndex ==
        (state as QuestionsLoaded).questions.length) {
      GoRouter.of(context).pushReplacementNamed(AppRouteConsts.endPage,);
      return;
    }
    final question = (state as QuestionsLoaded)
        .questions[(state as QuestionsLoaded).currentIndex];
    if (question.hashCode == Lesson.empty().hashCode) {
      final Lesson lesson = question;
      GoRouter.of(context)
          .pushReplacementNamed(AppRouteConsts.learn, extra: lesson);
      emit(QuestionsLoaded((state as QuestionsLoaded).questions,
          (state as QuestionsLoaded).currentIndex + 1));
      return;
    } else if (question.hashCode == ObjectiveQuestion.empty().hashCode) {
      final ObjectiveQuestion objectiveQuestion = question;
      GoRouter.of(context).pushReplacementNamed(
          AppRouteConsts.objectiveQuestion,
          extra: objectiveQuestion);
      emit(QuestionsLoaded((state as QuestionsLoaded).questions,
          (state as QuestionsLoaded).currentIndex + 1));
      return;
    } else if (question.hashCode == SubjectiveQuestion.empty().hashCode) {
      final SubjectiveQuestion subjectiveQuestion = question;
      GoRouter.of(context).pushReplacementNamed(
          AppRouteConsts.subjectiveQuestion,
          extra: subjectiveQuestion);
      emit(QuestionsLoaded((state as QuestionsLoaded).questions,
          (state as QuestionsLoaded).currentIndex + 1));
      return;
    } else if(question.hashCode == VoiceQuestion.empty().hashCode) {
      final VoiceQuestion voiceQuestion = question;
      GoRouter.of(context).pushReplacementNamed(
          AppRouteConsts.audioQuestion,
          extra: voiceQuestion);
      emit(QuestionsLoaded((state as QuestionsLoaded).questions,
          (state as QuestionsLoaded).currentIndex + 1));
      return;
    }
    else {
      debugPrint(question.runtimeType.toString());
    }
  }
}
