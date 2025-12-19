# Understanding Angular's `untracked()` Function

## Misconception ❌

**MISCONCEPTION**: "Using `untracked()` prevents OTHER effects from seeing changes to signals made inside the untracked block."

**REALITY**: `untracked()` only affects the CURRENT effect from being triggered by changes to signals referenced inside the untracked block.  Other effects will still react to signal changes made inside an untracked block.

## How `untracked()` Actually Works ✅

The `untracked()` function tells Angular: **"Don't track dependencies for signal reads inside this block FOR THIS EFFECT ONLY."**

- ✅ Signal changes made in `untracked()` are **still visible to other effects**
- ✅ Other effects **will still react** to those signal changes
- ❌ The current effect **won't re-run** when signals read inside `untracked()` change

## Real Code Example

Here's actual working code that demonstrates this behavior:

```typescript
export class App {
  SignalA = signal(0);
  SignalB = signal(0);

  constructor() {
    // Effect 1: Reads SignalA (tracked) and modifies SignalB (untracked)
    effect(() => {
      console.log('Effect 1 - SignalA value:', this.SignalA());
      
      // This untracked block:
      // ❌ Does NOT prevent Effect 2 from seeing SignalB changes
      // ✅ Does prevent Effect 1 from re-running when SignalB changes
      untracked(() => {
        this.SignalB.set(this.SignalB() + 1);
      });
    });

    // Effect 2: Watches SignalB
    effect(() => {
      // This WILL run when SignalB changes in Effect 1's untracked block!
      console.log('Effect 2 - SignalB value:', this.SignalB());
    });
  }

  // Wire this function to a button to test
  incrementSignalA() {
    this.SignalA.set(this.SignalA() + 1);
  }
}
```

## What Happens When You Click the Button

1. **Button clicked** → `incrementSignalA()` called
2. **SignalA changes** → Effect 1 runs (because it tracks SignalA)
3. **Effect 1 runs** → Logs SignalA value
4. **Inside untracked block** → SignalB is incremented
5. **SignalB changes** → Effect 2 runs (because it tracks SignalB)
6. **Effect 2 runs** → Logs SignalB value.  

## Testing This Yourself

Try the code above and click the increment button. You'll see SignalB value increment with every button press.  This could not happen if untracked() blocked outbound signal changes from propagating.