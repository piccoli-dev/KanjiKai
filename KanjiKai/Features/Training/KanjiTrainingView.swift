//
//  KanjiTrainingView.swift
//  KanjiKai
//
//  Created by Francesca Piccoli on 28/05/2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct KanjiTrainingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LearningProgressStore.self) private var progressStore

    @State private var kanji: KanjiItem
    @State private var currentStepIndex = 0
    @State private var currentStrokeIndex = 0
    @State private var completedPaths: [[CGPoint]] = []
    @State private var currentPath: [CGPoint] = []
    @State private var feedbackMessage = "Start from the highlighted point."
    @State private var isTrainingComplete = false
    @State private var isShowingInstructions = true
    @State private var hasAcknowledgedInstructions = false
    @State private var canvasShakeTrigger = 0

    init(kanji: KanjiItem) {
        _kanji = State(initialValue: kanji)
    }

    private var steps: [KanjiTrainingStep] {
        KanjiTrainingStep.steps(for: kanji)
    }

    private var strokes: [KanjiStroke] {
        KanjiVGStrokeProvider.strokes(for: kanji)
    }

    private var currentStep: KanjiTrainingStep {
        steps[currentStepIndex]
    }

    private var isCurrentStepComplete: Bool {
        completedPaths.count == strokes.count
    }

    var body: some View {
        Group {
            if isTrainingComplete {
                completionView
            } else {
                trainingContent
            }
        }
        .background(Color.creamBG.ignoresSafeArea())
        .navigationTitle("\(kanji.character) • \(kanji.localizedMeaning)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingInstructions = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(Color.primaryBrown)
                }
            }
        }
        .sheet(isPresented: $isShowingInstructions) {
            KanjiTrainingInstructionsSheet(
                onClose: closeInstructions,
                onUnderstand: closeInstructions
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: isShowingInstructions) { _, isShowing in
            if !isShowing {
                hasAcknowledgedInstructions = true
            }
        }
    }

    private var trainingContent: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 14)
                .background(Color.creamBG)

            ScrollView {
                VStack(spacing: 18) {
                    if case let .exampleWord(word, meaning) = currentStep.guideMode {
                        exampleWordCard(word: word, meaning: meaning)
                    }

                    KanjiDrawingCanvas(
                        guideCharacter: kanji.guideCharacter,
                        strokes: strokes,
                        currentStrokeIndex: currentStrokeIndex,
                        completedPaths: completedPaths,
                        currentPath: currentPath,
                        guideMode: currentStep.guideMode,
                        onDrawChanged: appendDrawnPoint,
                        onDrawEnded: finishStroke
                    )
                    .frame(maxWidth: .infinity)
                    .modifier(ShakeEffect(trigger: CGFloat(canvasShakeTrigger)))
                    .allowsHitTesting(hasAcknowledgedInstructions)

                    instructionCard
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .safeAreaInset(edge: .bottom) {
            floatingActionBar
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Step \(currentStepIndex + 1) of \(steps.count)")
                    .font(KanjiKaiFont.semiBold(16))
                    .foregroundStyle(Color.secondaryBrown)

                Spacer()

                Text("Stroke \(min(currentStrokeIndex + 1, strokes.count))/\(strokes.count)")
                    .font(KanjiKaiFont.medium(15))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.apricot.opacity(0.85))
                    .foregroundStyle(Color.primaryBrown)
                    .clipShape(Capsule())
            }

            ProgressView(value: Double(currentStepIndex), total: Double(steps.count))
                .tint(Color.primaryBrown)
        }
    }

    private var instructionCard: some View {
        YukiCard(backgroundColor: Color.warmWhite) {
            VStack(alignment: .leading, spacing: 4) {
                Text(currentStep.title)
                    .font(KanjiKaiFont.bold(22, relativeTo: .title3))
                    .foregroundStyle(Color.primaryBrown)

                Text(currentStep.instruction)
                    .font(KanjiKaiFont.regular(16))
                    .foregroundStyle(Color.secondaryBrown)

                Text(feedbackMessage)
                    .font(KanjiKaiFont.semiBold(15))
                    .foregroundStyle(isCurrentStepComplete ? Color.fujiBlue : Color.terracotta)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var actionRow: some View {
        HStack(spacing: 12) {
            Button {
                resetCurrentStroke()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
                    .font(KanjiKaiFont.semiBold(16))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .foregroundStyle(Color.primaryBrown)
                    .background(Color.warmWhite)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.primaryBrown.opacity(0.25), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Button {
                continueToNextStep()
            } label: {
                Text(currentStepIndex == steps.count - 1 ? "Finish" : "Continue")
                    .font(KanjiKaiFont.semiBold(16))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .foregroundStyle(isCurrentStepComplete ? Color.warmWhite : Color.secondaryBrown.opacity(0.7))
                    .background(isCurrentStepComplete ? Color.primaryBrown : Color.softGray.opacity(0.45))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!isCurrentStepComplete)
        }
    }

    private var floatingActionBar: some View {
        actionRow
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 10)
            .background(
                LinearGradient(
                    colors: [
                        Color.creamBG.opacity(0),
                        Color.creamBG,
                        Color.creamBG
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    private func exampleWordCard(word: String, meaning: String) -> some View {
        YukiCard(backgroundColor: Color.sky.opacity(0.55)) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.charcoal)

                    Text(meaning)
                        .font(KanjiKaiFont.medium(17))
                        .foregroundStyle(Color.secondaryBrown)
                }

                Spacer()

                Image(systemName: "book.pages.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.primaryBrown)
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 18) {
            Spacer()

            Text(kanji.character)
                .font(.system(size: 104, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primaryBrown)

            Text("Great job!")
                .font(KanjiKaiFont.bold(36, relativeTo: .largeTitle))
                .foregroundStyle(Color.primaryBrown)

            Text("You practiced \(kanji.character) 10 times.")
                .font(KanjiKaiFont.regular(19))
                .foregroundStyle(Color.secondaryBrown)

            PrimaryButton("Back to Training", icon: "checkmark.circle.fill") {
                dismiss()
            }
            .padding(.top, 12)

            Spacer()
        }
        .padding(24)
    }

    private func appendDrawnPoint(_ points: [CGPoint]) {
        guard hasAcknowledgedInstructions,
              !isCurrentStepComplete,
              let point = points.last else { return }
        currentPath.append(point)
    }

    private func finishStroke(_ points: [CGPoint]) {
        guard hasAcknowledgedInstructions, !isCurrentStepComplete else { return }

        if let point = points.last {
            currentPath.append(point)
        }

        guard let stroke = strokes[safe: currentStrokeIndex],
              KanjiStrokeValidator.validate(drawnPoints: currentPath, stroke: stroke) else {
            feedbackMessage = "Try again from the highlighted start point."
            currentPath = []
            playIncorrectFeedback()
            shakeCanvas()
            return
        }

        completedPaths.append(currentPath)
        currentPath = []

        if completedPaths.count == strokes.count {
            feedbackMessage = "Nice work. Continue when you are ready."
        } else {
            currentStrokeIndex += 1
            feedbackMessage = "Good. Now draw stroke \(currentStrokeIndex + 1)."
        }
    }

    private func resetCurrentStroke() {
        currentPath = []

        if !completedPaths.isEmpty {
            completedPaths.removeLast()
            currentStrokeIndex = max(completedPaths.count, 0)
        }

        feedbackMessage = "Try again from the highlighted start point."
    }

    private func continueToNextStep() {
        guard isCurrentStepComplete else { return }

        if currentStepIndex == steps.count - 1 {
            progressStore.markCompleted(kanji)
            isTrainingComplete = true
            return
        }

        currentStepIndex += 1
        currentStrokeIndex = 0
        completedPaths = []
        currentPath = []
        feedbackMessage = "Start from the highlighted point."
    }

    private func shakeCanvas() {
        withAnimation(.linear(duration: 0.35)) {
            canvasShakeTrigger += 1
        }
    }

    private func playIncorrectFeedback() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        #endif
    }

    private func closeInstructions() {
        hasAcknowledgedInstructions = true
        isShowingInstructions = false
    }
}

private struct KanjiTrainingInstructionsSheet: View {
    let onClose: () -> Void
    let onUnderstand: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("How to practice")
                .font(KanjiKaiFont.bold(30, relativeTo: .title))
                .foregroundStyle(Color.primaryBrown)
            
            VStack(alignment: .leading, spacing: 14) {
                instructionRow(icon: "1.circle.fill", text: "Draw each stroke in the highlighted order.")
                instructionRow(icon: "hand.draw.fill", text: "Start near the dot and move toward the arrow.")
                instructionRow(icon: "arrow.counterclockwise", text: "If a stroke feels wrong, reset and try again.")
                instructionRow(icon: "sparkles", text: "The hints fade as you move through the 10 steps.")
            }

            Spacer()

            PrimaryButton("I understand", icon: "checkmark.circle.fill", action: onUnderstand)
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
        .background(Color.creamBG)
    }

    private func instructionRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primaryBrown)
                .frame(width: 28)

            Text(text)
                .font(KanjiKaiFont.regular(17))
                .foregroundStyle(Color.secondaryBrown)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct ShakeEffect: GeometryEffect {
    var trigger: CGFloat

    var animatableData: CGFloat {
        get { trigger }
        set { trigger = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(trigger * .pi * 6) * 8
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        KanjiTrainingView(kanji: LocalKanjiDatabase.kanji(order: 4)!)
            .environment(LearningProgressStore())
    }
}
