{-# LANGUAGE OverloadedStrings #-}

module Main where

import Hakyll
import Text.Pandoc
import Data.Monoid (mappend)
import qualified Data.Map as M

postCtx :: Context String
postCtx = dateField "date" "%B %e, %Y" `mappend` defaultContext

static :: Rules ()
static = do
  match "img/*" $ route idRoute >> compile copyFileCompiler
  match "css/*" $ route idRoute >> compile compressCssCompiler
  match "js/*"  $ route idRoute >> compile copyFileCompiler

index :: Rules ()
index = do
  match "index.md" $ do
    route $ setExtension "html"
    compile $ compiler
      >>= loadAndApplyTemplate "templates/page.html" postCtx
      >>= relativizeUrls

pages :: Rules ()
pages = do
  match "pages/*.md" $ do
    route $ setExtension "html"
    compile $ compiler
      >>= loadAndApplyTemplate "templates/page.html" postCtx
      >>= relativizeUrls

dropPagesPrefix :: Routes
dropPagesPrefix = gsubRoute "pages/" $ const ""

templates :: Rules ()
templates = match "templates/*" $ compile templateCompiler

compiler :: Compiler (Item String)
compiler = pandocCompilerWith defaultHakyllReaderOptions pandocOptions

pandocOptions :: WriterOptions
pandocOptions = defaultHakyllWriterOptions{ writerHTMLMathMethod = MathJax "" }

cfg :: Configuration
cfg = defaultConfiguration { previewHost = "0.0.0.0" }

main :: IO ()
main = hakyllWith cfg $ static >> templates >> pages >> index
