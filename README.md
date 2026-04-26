# Chess CLI

A command line chess game programmed in Ruby and accompanied by a comprehensive
RSpec test suite, this project was developed as the capstone for the Ruby course
of [The Odin Project](https://www.theodinproject.com/) curriculum. See the [lesson
and project specifications](https://www.theodinproject.com/lessons/ruby-chess).
If you are unfamiliar with chess or could use a refresher, see the [Wikipedia
article on chess](https://en.wikipedia.org/wiki/Chess).

This project proved to be a considerable challenge and thoroughly exercised my
skills in:

- Object-oriented design
- Automated unit testing
- Project planning, organization and management
- Asking questions, communicating about development and implementing feedback
- Refactoring
- Debugging
- Version control
- and more...

## Getting Started

Assuming Ruby is installed in a supported environment:

- Clone this repository onto your local machine.
- `cd` into the cloned repo.
- Install the necessary dependencies and Ruby version.
- Run the main file to play.

For example:

```bash
git clone git@github.com:REDACTED/chess_cli.git
cd chess_cli/
bundle install
rbenv install
bundle exec ruby main.rb
```

## Features

### Responsive User Interface and Display

This software features a responsive user interface and display that informs the
user with helpful feedback, validates inputs and prevents illegal moves according
to the rules of chess.

[ux.webm](https://github.com/user-attachments/assets/b574d3a3-1104-45dc-b2f7-d30d7406c17d)

### Check

Check the opponent by attacking their king, but leaving them with at least one
legal move.

[check.webm](https://github.com/user-attachments/assets/c2f2f449-0237-4f19-8d7c-43b5c2722575)

### Checkmate

Checkmate the opponent by giving check to their king and leaving them without
any legal moves.

[checkmate.webm](https://github.com/user-attachments/assets/f076c38b-f2cd-4cd5-83f5-c48346ac48a9)

### Stalemate

The game draws by stalemate when the player to act is not in check, but has no
legal moves.

[stalemate.webm](https://github.com/user-attachments/assets/30e7e09c-0f86-496b-8947-9b16ac60cceb)

### Draw by Fifty-Move and Threefold Repetition Rules

The game draws by the fifty-move rule after fifty consecutive moves without any
captures or pawn moves, and the game draws by the threefold repetition rule when
an identical position has been repeated any three times. In the event that the
fifty-move rule and checkmate are invoked simultaneously, checkmate takes
precedence.

*Note*:
Typically in chess, the game is an automatic draw only by the seventy-five-move
or fivefold repetition rules, whereas the fifty-move and threefold repetition
rules merely allow players to claim a draw if they wish. This software instead
opts for a simplified implementation of automatic draw by the fifty-move or
threefold repetition rule, eliminating draw claims.

### En Passant

Capture en passant when a pawn is in position to capitalize on an en passant
target.

[en_passant.webm](https://github.com/user-attachments/assets/8793c3e5-91e5-4a25-9c92-17e4034e2542)

### Castling

Castle kingside or queenside when rights are intact, the way is clear and the
king would not move through check.

[castling.webm](https://github.com/user-attachments/assets/e87c39e0-276e-4bb5-9aca-f25b097b4b7a)

### Promotion

Promote a pawn when moving it to its last rank.

[promotion.webm](https://github.com/user-attachments/assets/e42dc018-e48c-4e05-8ea3-d48a262153dd)

### Double Pawn Push

Push a pawn two squares forward when moving it from its home rank.

[double_pawn_push.webm](https://github.com/user-attachments/assets/ccc7537a-f21b-4d47-83e6-db244edaca44)

### Save and Load

Save and exit a game in progress before any turn, then load it and continue
playing.

*Warning*:
This software does not verify the integrity of the save file, nor does it save
automatically except for at the end of a game. Tampering with the save file or
exiting the program outside of the provided mechanisms may cause unexpected
behavior.

[save_and_load.webm](https://github.com/user-attachments/assets/3088e56e-0ba4-4914-ab90-c4e240222ca1)

### Features Not Included

This software omits certain features you might expect either because they were
out of scope or because I decided not to pursue them, they include:

- Time control
- Draw offers
- Draw claims (see [Draw by Fifty-Move and Threefold Repetition Rules](#draw-by-fifty-move-and-threefold-repetition-rules))
- Draw by dead position
- AI opponent

## Retrospective

Development of this project subverted my expectations more than once and there
are a few key lessons learned that I would like to discuss in this retrospective.

For one, while I can still find testing to be tedious and laborious at times, I
discoverd the critical importance of testing and designing code that is conducive
to testing. Even if not strictly adhering to TDD, following best testing practices
proves code behavior, maintains codebase stability, allows for worry-free refactoring,
reduces debugging efforts and more.

Additionally, I learned to be wary of attempting to anticipate future features
by building infrastructure that is not immediately necessary. For example, when
initially developing the `Piece` class, I added state tracking how many times the
`Piece` has moved. I believed this would be imperative to later implement features
such as castling and the double pawn push. However, I eventually realized that the
state was not needed and caused difficulties with testing, so I removed it. There is
certainly nuance here, but I believe it is generally best to focus on building
only what is immediately vital to implement the next feature.

Finally, I gained significant experience in managing scope and feature creep by
planning and defining a clear scope and desired product. For example, in the initial
stages of development, I considered implementing features such as reversible game
history and logs. I ultimately decided that such efforts would be out of scope and
that I should at least focus on delivering the minimum viable product first. Without
proper scope control, development time can theoretically extend to infinity.

Through plenty of struggle during development, I gained skills, experience and
knowledge that I hope to carry with me into future projects.

## Acknowledgements

Thank you to the various members of The Odin Project community who supported and
guided me during development.

## Contributing

This project is not under active development and will likely not receive further
development. That said, if you discover a bug while play-testing, detailed reports
submitted as a GitHub issue are welcome and appreciated.

## A Note About AI

No "generative AI" tools were used in any capacity at any point during this
project's development.
