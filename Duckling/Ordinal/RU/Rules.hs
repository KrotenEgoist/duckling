-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree.


{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoRebindableSyntax #-}

module Duckling.Ordinal.RU.Rules
  ( rules
  ) where

import Data.HashMap.Strict (HashMap)
import Data.String
import Prelude
import qualified Data.HashMap.Strict as HashMap
import qualified Data.Text as Text

import Duckling.Dimensions.Types
import Duckling.Numeral.Helpers (parseInt)
import Duckling.Ordinal.Helpers
import Duckling.Regex.Types
import Duckling.Types

ordinalsFirstthMap :: HashMap Text.Text Int
ordinalsFirstthMap = HashMap.fromList
  [ ( "перв", 1 )
  , ( "втор", 2 )
  , ( "трет", 3 )
  , ( "четверт", 4 )
  , ( "четвёрт", 4 )
  , ( "пят", 5 )
  , ( "шест", 6 )
  , ( "седьм", 7 )
  , ( "восьм", 8 )
  , ( "девят", 9 )
  , ( "десят", 10 )
  , ( "одиннадцат", 11 )
  , ( "двенадцат", 12 )
  , ( "тринадцат", 13 )
  , ( "четырнадцат", 14 )
  , ( "пятнадцат", 15 )
  , ( "шестнадцат", 16 )
  , ( "семнадцат", 17 )
  , ( "восемнадцат", 18 )
  , ( "девятнадцат", 19 )
  , ( "двадцат", 20 )
  , ( "тридцат", 30 )
  , ( "сороков", 40 )
  , ( "пятидесят", 50 )
  , ( "шестидесят", 60 )
  , ( "семидесят", 70 )
  , ( "восьмидесят", 80 )
  , ( "девяност", 90 )
  , ( "сот", 100 )
  ]

cardinalsMap :: HashMap Text.Text Int
cardinalsMap = HashMap.fromList
  [ ( "двадцать", 20 )
  , ( "тридцать", 30 )
  , ( "сорок", 40 )
  , ( "пятьдесят", 50 )
  , ( "шестьдесят", 60 )
  , ( "семьдесят", 70 )
  , ( "восемьдесят", 80 )
  , ( "девяносто", 90 )
  , ( "сто", 100 )
  ]

ruleOrdinalsFirstth :: Rule
ruleOrdinalsFirstth = Rule
  { name = "ordinals (first..20th, then 30th, 40th, ..., 100th)"
  , pattern =
    [ regex "(перв|втор|трет|четв[её]рт|пят|шест|седьм|восьм|девят|десят|одиннадцат|двенадцат|тринадцат|четырнадцат|пятнадцат|шестнадцат|семнадцат|восемнадцат|девятнадцат|двадцат|тридцат|сороков|пятидесят|шестидесят|семидесят|восьмидесят|девяност|сот)(ь(его|ему|ей|ем|им|их|и|е|ю)|ого|ому|ый|ой|ий|ая|ое|ья|ом|ые|ым|ых|ую)"
    ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match:_)):_) ->
        ordinal <$> HashMap.lookup (Text.toLower match) ordinalsFirstthMap
      _ -> Nothing
  }

ruleOrdinal :: Rule
ruleOrdinal = Rule
  { name = "ordinal 21..99"
  , pattern =
    [ regex "(двадцать|тридцать|сорок|пятьдесят|шестьдесят|семьдесят|восемьдесят|девяносто)"
    , regex "(перв|втор|трет|четв[её]рт|пят|шест|седьм|восьм|девят)(ь(его|ей|ю)?|ого|ому|ый|ой|ий|ая|ое|ья|ые|ым|ых|ую)"
    ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (m1:_)):
       Token RegexMatch (GroupMatch (m2:_)):
       _) -> do
         dozen <- HashMap.lookup (Text.toLower m1) cardinalsMap
         unit <- HashMap.lookup (Text.toLower m2) ordinalsFirstthMap
         Just . ordinal $ dozen + unit
      _ -> Nothing
  }

ruleOrdinalDigits :: Rule
ruleOrdinalDigits = Rule
  { name = "ordinal (digits)"
  , pattern =
    [ regex "0*(\\d+)-?((ы|о|и|а|е|ь)?(ее|й|я|е|го|му|ую?))"
    ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match:_)):_) -> ordinal <$> parseInt match
      _ -> Nothing
  }

rules :: [Rule]
rules =
  [ ruleOrdinal
  , ruleOrdinalDigits
  , ruleOrdinalsFirstth
  ]

