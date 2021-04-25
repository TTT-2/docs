# Creating a Role

## Role Variables

### Scoring

There are a few variables that influence the scoring of the role. They are all in the `score` table of the role. Here are the existing variables from the role base with their default values.

```lua
-- The multiplier that is used to calculate the score penalty
-- that is added if this role kills a team member.
teamKillsMultiplier = 0,

-- The multiplier that is used to calculate the gained score
-- by killing someone from a different team.
killsMultiplier = 0,

-- The amount of score points gained by confirming a body.
bodyFoundMuliplier = 1,

-- The amount of score points gained by surviving a round,
-- based on the amount of dead enemy players.
surviveBonusMultiplier = 0,

-- The amount of score points granted due to a survival of the
-- round for every teammate alive.
aliveTeammatesBonusMultiplier = 1,

-- Multiplier for a score for every player alive at the end of
-- the round. Can be negative for roles that should kill everyone.
allSurviveBonusMultiplier = 0,

-- The amount of score points gained by being alive if the
-- round ended with nobody winning, usually a negative number.
timelimitMultiplier = 0,

-- the amount of points gained by killing yourself. Should be a
-- negative number for most roles.
suicideMultiplier = -1
```

[[Find them in the role base]](https://github.com/TTT-2/TTT2/blob/master/lua/terrortown/entities/roles/ttt_role_base/shared.lua)
