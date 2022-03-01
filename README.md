# swiftui-pausable-animation

**Easily pause and resume SwiftUI animations!**

![Preview](https://github.com/globulus/swiftui-pausable-animation/blob/main/Images/preview.gif?raw=true)

## Installation

This component is distributed as a **Swift package**. Just add this repo's URL to XCode:

```text
https://github.com/globulus/swiftui-pausable-animation
```

## How to use

Add the `pausableAnimation` modifier to your view. It takes five parameters:

1. `binding` - the property changed when animating, e.g opacity, offset, rotation angle, etc. It needs to be a `@Binding` since the modifier will change its value when the animation is paused or resumed.
1. `targetValue` - this is the final value you're setting the animated property to. E.g, if you're fading something in by changing the opacity from 0 to 1, this value will be 1. The modifier needs to know it in order to be able to resume the animation.
1. `remainingDuration` - this is a block that tells how for long does the animation last, depending on its current position. E.g, if you're changing opacity from 0 to 1 over 5 seconds, and pause the animation at 2 seconds, the current opacity will be 0.4. This block should be able to take 0.4 and say that 3 seconds more are needed to complete the animation.
1. `animation` - this is a block that tells which animation to use on resume. Its parameter is the duration of the animation, derived from calling `remainingDuration`.
1. `isPaused` - set this binding to `true` to pause the animation and to `false` to resume it.

```swift
import SwiftUIPausableAnimation

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
```

## Recipe

Check out [this recipe](https://swiftuirecipes.com/blog/pause-and-resume-animation-in-swiftui) for in-depth description of the component and its code. Check out [SwiftUIRecipes.com](https://swiftuirecipes.com) for more **SwiftUI recipes**!

## Changelog

* 1.0.0 - Initial release.
