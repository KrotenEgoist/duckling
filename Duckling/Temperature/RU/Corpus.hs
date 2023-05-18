-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree.


{-# LANGUAGE OverloadedStrings #-}

module Duckling.Temperature.RU.Corpus
  ( corpus
  ) where

import Prelude
import Data.String

import Duckling.Locale
import Duckling.Temperature.Types
import Duckling.Resolve
import Duckling.Testing.Types

corpus :: Corpus
corpus = (testContext {locale = makeLocale RU Nothing}, testOptions, allExamples)

allExamples :: [Example]
allExamples = concat
  [ examples (simple Degree 45)
             [ "45°"
             , "45 градусов"
             ]
  , examples (simple Degree (-2))
             [ "-2°"
             , "- 2 градуса"
             ]
  ]
