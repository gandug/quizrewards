🧠 QuizRewards - A Quiz-Based Reward Smart Contract on Stacks

QuizRewards is a Clarity smart contract designed for the Stacks blockchain that enables decentralized quiz competitions with STX token rewards. Quiz creators can post questions, participants can submit answers, and correct participants can claim a share of the reward pool.

---

  Features

- ✅ **Create Quizzes**: Define a question, multiple-choice options, and the correct answer.
- 📝 **Submit Answers**: Participants can submit their answers before the quiz closes.
- ⏱ **Time-Locked Participation**: Submissions are only accepted within a valid time window.
- 🏆 **Reveal Winners**: After the quiz closes, winners are automatically determined.
- 💰 **Claim Rewards**: Correct participants can claim an equal share of the prize pool.
- 🔐 **Access Control**: Only the quiz creator or contract admin can reveal winners and distribute rewards.

---

 📄 Contract Functions

| Function | Description |
|---------|-------------|
| `create-quiz (quiz-id question options correct-option deadline)` | Creates a new quiz. |
| `submit-answer (quiz-id selected-option)` | Submits a user's answer to a specific quiz. |
| `reveal-winners (quiz-id)` | Reveals correct answers and marks eligible winners. |
| `claim-reward (quiz-id)` | Allows winners to claim their share of the STX reward pool. |
| `get-quiz (quiz-id)` | Retrieves quiz details. |

---

  Getting Started

 Prerequisites

- [Clarinet](https://docs.stacks.co/write-smart-contracts/clarinet) installed
- Stacks wallet for testing on devnet/testnet

 Run Tests

```bash
clarinet test
