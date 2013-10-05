# -*- encoding: utf-8 -*-
require 'spec_helper'

describe JavaVersion do
  describe ".valid?" do
    it "JDK7u40を受け取った時trueを返す" do
      expect(JavaVersion.valid?("JDK7u40")).to be_true
    end

    it "hogeを受け取った時falseを返す" do
      expect(JavaVersion.valid?("hoge")).to be_false
    end

    it "JDK7u9xを受け取った時falseを返す" do
      expect(JavaVersion.valid?("JDK7u9x")).to be_false
    end

    it "JDK740を受け取った時falseを返す" do
      expect(JavaVersion.valid?("JDK740")).to be_false
    end
  end

  describe ".parse" do
    it "JDK7u40を受け取った時、JavaVersionクラスのインスタンスを返す"do
      expect(JavaVersion.parse("JDK7u40")).to be_an_instance_of(JavaVersion)
    end

    it "JDK7u9xを受け取った時、例外を発生する" do
      expect{JavaVersion.parse("JDK7u9x")}.to raise_error(ArgumentError)
    end
  end

  describe "#family_number" do
    it "JDK7u40を受け取った時、7を返す" do
      version= JavaVersion.parse("JDK7u40")
      expect(version.family_number).to eq(7)
    end

    it "JDK10u110を受け取った時、10を返す" do
      version= JavaVersion.parse("JDK10u110")
      expect(version.family_number).to eq(10)
    end
  end

  describe "#update_number" do
    it "JDK7u40を受け取った時、40を返す" do
      version= JavaVersion.parse("JDK7u40")
      expect(version.update_number).to eq(40)
    end

    it "JDK10u110を受け取った時、110を返す" do
      version= JavaVersion.parse("JDK10u110")
      expect(version.update_number).to eq(110)
    end
  end

  describe "比較演算子" do
    before do
      @jdk7u40 = JavaVersion.new(7,40)
      @jdk7u51 = JavaVersion.new(7,51)
      @jdk8u0  = JavaVersion.new(8,0)
    end

    describe "#<" do
      it "JDK7u40とJDK7u51を比較した結果trueを返す" do
        expect(@jdk7u40 < @jdk7u51).to be_true
      end

      it "JDK7u51とJDK7u40を比較した結果falseを返す" do
        expect(@jdk7u51 < @jdk7u40).to be_false
      end

      it "JDK7u40とJDK8u0を比較した結果trueを返す" do
        expect(@jdk7u40 < @jdk8u0).to be_true
      end
    end

    describe "#>" do
      it "JDK7u40とJDK7u51を比較した結果falseを返す" do
        expect(@jdk7u40 > @jdk7u51).to be_false
      end

      it "JDK7u51とJDK7u40を比較した結果trueを返す" do
        expect(@jdk7u51 > @jdk7u40).to be_true
      end

      it "JDK7u40とJDK8u0を比較した結果trueを返す" do
        expect(@jdk7u40 > @jdk8u0).to be_false
      end
    end
  end

  describe "#next_security_update" do
    it  "JDK7u45の次のセキュリティアラートは46になる" do
      jdk7u45 = JavaVersion.new(7, 45)
      expect(jdk7u45.next_security_update).to eq(46)
    end

    it  "JDK10u123の次のセキュリティアラートは124になる" do
      jdk10u123 = JavaVersion.new(10, 123)
      expect(jdk10u123.next_security_update).to eq(124)
    end
  end

  describe "#next_critical_patch_update" do
    it  "JDK7u40の次のパッチアップデートは45になる" do
      jdk7u40 = JavaVersion.new(7, 40)
      expect(jdk7u40.next_critical_patch_update).to eq(45)
    end

    it  "JDK7u45の次のパッチアップデートは51になる" do
      jdk7u45 = JavaVersion.new(7, 45)
      expect(jdk7u45.next_critical_patch_update).to eq(51)
    end

    it  "JDK10u123の次のセキュリティアラートは125になる" do
      jdk10u123 = JavaVersion.new(10, 123)
      expect(jdk10u123.next_critical_patch_update).to eq(125)
    end
  end

  describe "#next_security_update" do
    it  "JDK7u40の次のセキュリティアラートは60になる" do
      jdk7u40 = JavaVersion.new(7, 40)
      expect(jdk7u40.next_limited_update).to eq(60)
    end

    it  "JDK10u79の次のセキュリティアラートは80になる" do
      jdk10u79 = JavaVersion.new(10, 79)
      expect(jdk10u79.next_limited_update).to eq(80)
    end
  end
end
