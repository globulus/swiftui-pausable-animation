import SwiftUI

public typealias RemainingDurationProvider<Value: VectorArithmetic> = (Value) -> TimeInterval
public typealias AnimationWithDurationProvider = (TimeInterval) -> Animation

public extension Animation {
  static let instant = Animation.linear(duration: 0.0001)
}

public struct PausableAnimationModifier<Value: VectorArithmetic>: AnimatableModifier {
  @Binding var binding: Value
  @Binding var paused: Bool
  
  private let targetValue: Value
  private let remainingDuration: RemainingDurationProvider<Value>
  private let animation: AnimationWithDurationProvider
  
  public var animatableData: Value

  public init(binding: Binding<Value>,
              targetValue: Value,
              remainingDuration: @escaping RemainingDurationProvider<Value>,
              animation: @escaping AnimationWithDurationProvider,
              paused: Binding<Bool>) {
    _binding = binding
    self.targetValue = targetValue
    self.remainingDuration = remainingDuration
    self.animation = animation
    _paused = paused
    animatableData = binding.wrappedValue
  }
  
  public func body(content: Content) -> some View {
    content
      .onChange(of: paused) { isPaused in
        if isPaused {
          withAnimation(.instant) {
            binding = animatableData
          }
        } else {
          withAnimation(animation(remainingDuration(animatableData))) {
            binding = targetValue
          }
        }
      }
  }
}

public extension View {
  func pausableAnimation<Value: VectorArithmetic>(binding: Binding<Value>,
                                                  targetValue: Value,
                                                  remainingDuration: @escaping RemainingDurationProvider<Value>,
                                                  animation: @escaping AnimationWithDurationProvider,
                                                  paused: Binding<Bool>) -> some View {
    self.modifier(PausableAnimationModifier(binding: binding,
                                            targetValue: targetValue,
                                            remainingDuration: remainingDuration,
                                            animation: animation,
                                            paused: paused))
  }
}

struct PausableAnimationTest: View {
  @State private var angle = 0.0
  @State private var isPaused = false
  
  private let duration: TimeInterval = 6
  private let startAngle = 0.0
  private let endAngle = 360.0
  private var remainingDuration: RemainingDurationProvider<Double> {
    { currentAngle in
      duration * (1 - (currentAngle - startAngle) / (endAngle - startAngle))
    }
  }
  private let animation: AnimationWithDurationProvider = { duration in
    .linear(duration: duration)
  }
  
  var body: some View {
    VStack {
      ZStack {
        Text("I'm slowly rotating!")
          .rotationEffect(.degrees(angle))
          .pausableAnimation(binding: $angle,
                             targetValue: endAngle,
                             remainingDuration: remainingDuration,
                             animation: animation,
                             paused: $isPaused)
      }
      .frame(height: 300)
      Button(isPaused ? "Resume" : "Pause") {
        isPaused = !isPaused
      }
    }
    .onAppear {
      angle = startAngle
      withAnimation(animation(duration)) {
        angle = endAngle
      }
    }
  }
}

struct PausableAnimation_Previews: PreviewProvider {
    static var previews: some View {
        PausableAnimationTest()
    }
}
